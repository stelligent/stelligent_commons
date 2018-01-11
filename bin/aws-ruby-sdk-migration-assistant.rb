#!/usr/bin/env ruby

#####
## Assists with upgrading from V2 to V3 of the AWS Ruby SDK
## by telling you which includes your missing for various
## service clients or resources your using
#####

# Usage: ./aws-ruby-sdk-migration-assistant.rb path/to/your/files/lol

ignore = %w[assumerolecredentials waiters]

Dir.glob("#{ARGV[0]}/*").each do |file|
  next unless File.file?(file)

  file_contents = File.read(file)
  file_contents.scan(/[^'"]AWS::([a-zA-Z0-9]+)/im).map { |s| s.map(&:downcase) }.each do |aws_services|
    aws_services.each do |aws_service|
      next if ignore.include? aws_service
      require_name = "aws-sdk-#{aws_service}"

      unless file_contents =~ Regexp.new(require_name, Regexp::IGNORECASE)
        puts "File: #{file} missing include for #{require_name}!"
      end
    end
  end
end
