directory File.dirname(node['jenkins']['http_proxy']['ssl']['cert_path']) do
  recursive true
  mode '0500'
end

bash 'generate a self-signed certificate' do
  code <<-END
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '#{node[:jenkins][:cert_subject]}' -keyout  #{node['jenkins']['http_proxy']['ssl']['key_path']} -out  #{node['jenkins']['http_proxy']['ssl']['cert_path']}
  END
end

file node['jenkins']['http_proxy']['ssl']['cert_path'] do
  mode '0500'
end

file node['jenkins']['http_proxy']['ssl']['key_path'] do
  mode '0500'
end