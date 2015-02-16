# Turn on matrix based authentication

cookbook_file "script to add Jenkins security and users" do
  source "create_maxtrix_sec.groovy"
  path "/tmp/create_maxtrix_sec.groovy"
end

users = node['jenkins_security']['users'].collect {|user| "#{user[0]} #{user[1]} #{user[2]}"}.each do |args|
  jenkins_command "add global variables" do
    command "groovy /tmp/create_maxtrix_sec.groovy #{args}"
    only_if { node['jenkins_security']['authz_strategy'] == 'matrix' }
  end
end

