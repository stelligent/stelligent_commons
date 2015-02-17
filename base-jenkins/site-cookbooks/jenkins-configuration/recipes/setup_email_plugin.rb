# for our scripts later to be able to know this ohai resource
file '/etc/admin_email' do
  owner 'root'
  group 'root'
  content node['jenkins']['email']['admin_email_address']
  mode 0644
end

template '/etc/sysconfig/jenkins' do
  owner 'root'
  group 'root'
  source 'jenkins-sysconfig.erb'
  mode 0644
end

template '/var/lib/jenkins/hudson.plugins.emailext.ExtendedEmailPublisher.xml' do
  source 'hudson.plugins.emailext.ExtendedEmailPublisher.xml.erb'
  mode 0644
  owner 'jenkins'
  group 'jenkins'
  variables(
    {
      :domain         => node['jenkins']['global_vars']['domain'],
      :email_username => node['jenkins']['email']['username'],
      :email_password => compute_ses_smtp_password(node['jenkins']['email']['secret_key']),
      :email_address  => node['jenkins']['email']['admin_email_address'],
      :smtp_server    => node['jenkins']['email']['smtp_server'],
      :smtp_port      => node['jenkins']['email']['smtp_port'],
      :jenkins_url    => node['jenkins']['email']['jenkins_url']
    }
  )
end