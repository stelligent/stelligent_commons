apt_repository 'nginx-php' do
  uri          'https://oss-binaries.phusionpassenger.com/apt/passenger'
  distribution 'trusty'
  components   ['main']
  keyserver    'keyserver.ubuntu.com'
  key          '561F9B9CAC40B2F7'
  deb_src      true
end


package "apt-transport-https" do
  action :install
end

package "ca-certificates" do
  action :install
end

package "nginx-extras" do
  action :install
end

package "passenger" do
  action :install
end

template "/etc/nginx/nginx.conf" do
  source "nginx.conf.erb"
  action :create
  notifies :restart, "service[nginx]", :immediately
end

service "nginx" do
  action :nothing
end


