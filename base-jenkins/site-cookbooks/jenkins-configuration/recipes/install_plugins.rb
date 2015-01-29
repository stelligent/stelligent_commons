# install all packages from jenkins-server-plugins array to mimic
# previous cookbook's behavior

#this code might be over wrought if doing disposable instances
node['jenkins']['server']['plugins'].each do |plugin|
  jenkins_plugin plugin['name'] do
    action :uninstall
  end
  jenkins_plugin plugin['name'] do
    version plugin['version'] unless plugin['version'].nil?
    install_deps false
  end
  file "/var/lib/jenkins/plugins/#{plugin['name']}.jpi.pinned" do
    action :create
    owner 'jenkins'
    group 'jenkins'
    mode '0644'
  end
end

# wait 10 seconds for jenkins to stop responding on its
# listener
execute 'wait for jenkins to restart' do
  command 'service jenkins restart;sleep 10'
end

jenkins_command 'version'