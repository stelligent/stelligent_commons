require 'rake'
require 'rspec/core/rake_task'

task :serverspec    => 'serverspec:all'

namespace :serverspec do
  targets = []
  Dir.glob('./serverspec/*').each do |dir|
    next unless File.directory?(dir)
    targets << File.basename(dir)
  end

  task :all     => targets

  targets.each do |target|
    desc "Run serverspec tests to #{target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV['TARGET_HOST'] = target
      t.pattern = "serverspec/#{target}/*_spec.rb"
    end
  end
end


