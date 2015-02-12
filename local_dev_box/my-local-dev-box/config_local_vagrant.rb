# Script to config local vagrant.yml file used by Vagrant.
#
# localpath (required): absolute path of local project dir to share with vagrant machine
# guestpath (optional): absolute path of vagrant data on vm
# cpus (optional): number of CPUs to allocate
# memory (optional): amount of memory in MB to allocate
#
# Execution:
# ruby config_vagrant.rb -l <path> -g <path> -c <#> -m <#>

require 'optparse'
require 'ostruct'
require 'yaml'
require 'fileutils'

# set default values
@opts = OpenStruct.new
@opts.guestpath = '/vagrant_data'
@opts.cpus = 2
@opts.memory = 4096
@vagrant = 'vagrant.yml'
@vagrantfile = File.join(__dir__, 'Vagrantfile')
@vagrantfile_example = File.join(__dir__, 'LocalVagrantfile.example')
@file = File.join(__dir__, @vagrant)

# create vagrantfile from vagrantfile.example
def create_vagrantfile
  return if File.exist?(@vagrantfile)
  unless File.exist?(@vagrantfile_example)
    puts 'Error: Vagrantfile.example does not exist! Unable to create Vagrantfile.'
    return
  end
  FileUtils.cp 'LocalVagrantfile.example', 'Vagrantfile'
end

# import current file settings if file exists
def import_settings
  return unless File.exist?(@file)
  prev_settings = YAML.load_file(@file)
  if prev_settings.key?(:synced_folder)
    @opts.localpath = prev_settings[:synced_folder][:localpath] if prev_settings[:synced_folder].key?(:localpath)
    @opts.guestpath = prev_settings[:synced_folder][:guestpath] if prev_settings[:synced_folder].key?(:guestpath)
  end

  return unless prev_settings.key?(:hardware)
  @opts.cpus = prev_settings[:hardware][:cpus] if prev_settings[:hardware].key?(:cpus)
  @opts.memory = prev_settings[:hardware][:memory] if prev_settings[:hardware].key?(:memory)
end

# parse command line args and replace info as needed
def parse_args
  OptionParser.new do |opts|
    opts.on('-localpath', '--localpath', 'Set localpath for host shared folder') do |localpath|
      begin
        fail OptionParser::InvalidArgument unless localpath
        @opts.localpath = localpath
      rescue OptionParser::InvalidArgument => e
        puts e.message + 'Localpath is required'
      end
    end
    opts.on('-guestpath', '--guestpath', 'Set guestpath for guest shared folder') do |guestpath|
      begin
        fail OptionParser::InvalidArgument unless guestpath.start_with?('/')
        @opts.guestpath = guestpath
      rescue OptionParser::InvalidArgument => e
        puts e.message + 'Guestpath should start with \'/\''
      end
    end
    opts.on('-cpu', '--cpu', '-cpus', '--cpus', OptionParser::DecimalInteger, 'Set number of VM cpus') do |cpus|
      begin
        fail OptionParser::InvalidArgument unless cpus.between?(1, 10)
        @opts.cpus = cpus
      rescue OptionParser::InvalidArgument => e
        puts e.message + 'Number of cpus should be between 1 and 10'
      end
    end
    opts.on('-memory', '--memory', OptionParser::DecimalInteger, 'Set available VM memory') do |memory|
      begin
        fail OptionParser::InvalidArgument unless memory.between?(4096, 32_768)
        @opts.memory = memory
      rescue OptionParser::InvalidArgument => e
        puts e.message + 'Amount of memory should be between 4096 and 32768 (MB)'
      end
    end
  end.parse!
end

def update
  File.open(@vagrant, 'w') { |file| YAML.dump @content, file }
end

def format
  content = File.read(@vagrant)
  content.gsub!('- ', '  ')
  File.open(@vagrant, 'w') { |file| file.write content }
end

create_vagrantfile
import_settings
parse_args
@content = {
  synced_folder: [{localpath: @opts.localpath}, {guestpath: @opts.guestpath}],
  hardware: [{cpus: @opts.cpus}, {memory: @opts.memory}]
}
update
format

puts 'Done!'
