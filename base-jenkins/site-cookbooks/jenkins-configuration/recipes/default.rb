include_recipe 'jenkins-configuration::docker'
include_recipe 'jenkins-configuration::install_plugins'
include_recipe 'jenkins-configuration::git'
include_recipe 'jenkins-configuration::vars'
include_recipe 'jenkins-configuration::jenkins-security'
include_recipe 'jenkins-configuration::setup_email_plugin'

if node['jenkins']['http_proxy']['ssl']['enabled']
  include_recipe 'jenkins-configuration::generate-cert'
end
