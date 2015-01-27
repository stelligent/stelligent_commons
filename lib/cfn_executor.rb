require 'aws-sdk'

class CloudFormationExecutor


  def execute(stack_name, io, parameters = {}, wait=false)

    success = true

    begin
      cfm = AWS::CloudFormation.new
      stack = cfm.stacks.create(stack_name,
                                io.read,
                                :parameters => parameters,
                                :capabilities => %w{CAPABILITY_IAM},
                                :disable_rollback => true)
      if wait
        sleep_time = 10000
        silent = false
        success = watch_loop(stack, sleep_time, silent)
      end
    rescue AWS::CloudFormation::Errors::ValidationError => msg
      print_status "Exception raised: #{msg}"
      success = false
    end
    return success
  end

  private

  SUCCESS_STATUSES =  %w{CREATE_COMPLETE
                         UPDATE_COMPLETE}

  FAILURE_STATUSES =  %w{CREATE_FAILED
                         ROLLBACK_FAILED
                         ROLLBACK_COMPLETE
                         DELETE_FAILED
                         UPDATE_ROLLBACK_FAILED
                         UPDATE_ROLLBACK_COMPLETE
                         DELETE_COMPLETE}

  PROGRESS_STATUSES = %w{CREATE_IN_PROGRESS
                         ROLLBACK_IN_PROGRESS
                         DELETE_IN_PROGRESS
                         UPDATE_IN_PROGRESS
                         UPDATE_COMPLETE_CLEANUP_IN_PROGRESS
                         UPDATE_ROLLBACK_IN_PROGRESS
                         UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS}
  def wait_for_stack(stack, wait)
    if wait
      while stack.status != 'CREATE_COMPLETE'
        sleep 20

        if FAILURE_STATUSES.include? stack.status
          raise "Stack #{stack.name} failed: #{stack.status}"
        end
      end
    end
  end

  def print_status(status, silent=false)
    timestamp = Time.now.strftime('%Y.%m.%d %H:%M:%S:%L')
    unless silent
      puts "#{timestamp}: #{status}"
    end
  end

  def watch_loop(stack, sleep_time, silent)
    keep_watching = true
    success = false
    abort_count = 10
    while(keep_watching) do
      begin
        stack_status = stack.status
        if (SUCCESS_STATUSES.include? stack_status)
          status = "Success: #{stack_status}"
          print_status(status, silent)
          success = true
          keep_watching = false
        elsif (PROGRESS_STATUSES.include? stack_status)
          status = "In Progress: #{stack_status}"
          print_status(status, silent)
          success = false
          keep_watching = true
        elsif (FAILURE_STATUSES.include? stack_status)
          status = "Failed: #{stack_status}"
          print_status(status, silent)
          success = false
          keep_watching = false
        else
          status = "didn't find #{stack_status} in the list of expected statuses"
          print_status(status, silent)
          success = false
          abort_count = abort_count - 1
          # if we get too many unknown statuses, assume something has gone horribly wrong and quit.
          keep_watching = (abort_count > 0)
        end
      rescue AWS::CloudFormation::Errors::Throttling
        status = "Rate limit exceeded, retrying..."
        print_status(status, silent)
        sleep (sleep_time * 0.1)
      end
      if keep_watching
        sleep(sleep_time)
      end
    end
    return success
  end

end