# Turn on matrix based authentication

cookbook_file "script to add Jenkins security and users" do
  source "create_maxtrix_sec.groovy"
  path "/tmp/create_maxtrix_sec.groovy"
end

jenkins_command "add global variables" do
  command "groovy /tmp/create_maxtrix_sec.groovy"
  only_if { node['jenkins_security']['authz_strategy'] == 'matrix' }
end