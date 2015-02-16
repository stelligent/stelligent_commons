include_recipe 'jenkins-configuration::install_plugins'
include_recipe 'jenkins-configuration::git'
include_recipe 'jenkins-configuration::vars'
include_recipe 'jenkins-configuration::jenkins-security'

if node['jenkins']['http_proxy']['ssl']['enabled']
  include_recipe 'jenkins-configuration::generate-cert'
end
