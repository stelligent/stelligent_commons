ssl_dir = '/etc/httpd/ssl'

bash 'generate a self-signed certificate' do

  code <<-END
    mkdir -p #{ssl_dir}
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '#{node[:jenkins][:cert_subject]}' -keyout #{ssl_dir}/server.key -out #{ssl_dir}/server.crt
    chmod -R 0500 #{ssl_dir}
  END
end