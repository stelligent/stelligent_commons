require 'spec_helper'

describe apache_site('jenkins') do
  it { should be_enabled }
end

describe apache_site('jenkins2') do
  it { should_not be_enabled }
end

apache_modules_to_be_enabled = %w{proxy proxy_http vhost_alias ssl rewrite}
apache_modules_to_be_enabled.each do |apache_module_to_be_enabled|
  describe apache_module(apache_module_to_be_enabled) do
    it { should be_installed_to_apache }
  end
end


# describe apache_virtual_host('jenkins') do
#   #it { should have_pattern('*:80')}
#   #it { should have_pattern('*:8443')}
#
#   #it { should have_redirect('*:80', '*:8443')}
#   #      RewriteEngine On
#   #RewriteCond %{HTTP_HOST} ^www.<%= @host_name %>$ [NC]
#   #RewriteRule ^/(.*)$ http://<%= @host_name %>/$1 [R=301,L]
#
#   #it { should have_ssl_settings }
#   #SSLEngine on
#   #SSLCertificateFile <%= node['jenkins']['http_proxy']['ssl']['cert_path'] %>
#   #    SSLCertificateKeyFile <%= node['jenkins']['http_proxy']['ssl']['key_path'] %>
#   #<% if node['jenkins']['http_proxy']['ssl']['ca_cert_path'] -%>
#   #    SSLCACertificateFile <%= node['jenkins']['http_proxy']['ssl']['ca_cert_path'] %>
# end