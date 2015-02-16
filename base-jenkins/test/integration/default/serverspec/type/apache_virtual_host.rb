#    <VirtualHost *:80>
#ServerName        jenkins
#<% node['jenkins']['http_proxy']['host_aliases'].each do |a| -%>
#      ServerAlias       www.<%= a %>
#<% end -%>

#      RewriteEngine On
#      RewriteCond %{HTTP_HOST} ^www.<%= @host_name %>$ [NC]
#RewriteRule ^/(.*)$ http://<%= @host_name %>/$1 [R=301,L]
#</VirtualHost>


module Serverspec
  module Type
    class ApacheVirtualHost < Base
      def initialize(virtual_host_name)
        @virtual_host_name = virtual_host_name
      end

      def something
        #*:80                   jenkins (/etc/apache2/sites-enabled/jenkins.conf:2)
        #*:8443                 jenkins
      end
    end

    def apache_virtual_host(virtual_host_name)
      ApacheVirtualHost.new(virtual_host_name)
    end
  end
end

include Serverspec::Type