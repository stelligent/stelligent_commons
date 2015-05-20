package 'git' do
  action :install
end

directory "#{node[:jenkins][:master][:home]}/.ssh" do
  action :create
  mode 0700
  user node[:jenkins][:master][:user]
  group node[:jenkins][:master][:group]
end

bash 'setup git for jenkins user' do
  code <<-END
    su -c 'git config --global user.name #{node[:jenkins_git][:username]}' -s /bin/bash - jenkins
    su -c 'git config --global user.email #{node[:jenkins_git][:email]}' -s /bin/bash - jenkins
  END
end

bash 'setup known hosts for jenkins user' do
  code <<-END
    ssh-keyscan github.com > #{node[:jenkins][:master][:home]}/.ssh/known_hosts
  END
end

file "#{node[:jenkins][:master][:home]}/.ssh/known_hosts" do
  user node[:jenkins][:master][:user]
  group node[:jenkins][:master][:group]
  mode 0600
end
