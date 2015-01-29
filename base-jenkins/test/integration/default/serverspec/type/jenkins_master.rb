require 'jenkins_api_client'

module Serverspec
  module Type
    class JenkinsMaster < Base
      def initialize(server_url, username=nil, password=nil)
        @server_url = server_url
        @username = username
        @password = password

        @client = JenkinsApi::Client.new(:server_url => @server_url,
                                         :username => @username,
                                         :password => @password)
      end
    end

    def has_plugin?(name, version)
      puts @client.plugin.list_installed
      return false unless @client.plugin.list_installed.has_key? name
      if version.nil?
        true
      else
        @client.plugin.list_installed[name] == version
      end
    end

    def jenkins_master(server_url, username=nil, password=nil)
      JenkinsMaster.new(server_url, username, password)
    end
  end
end

include Serverspec::Type