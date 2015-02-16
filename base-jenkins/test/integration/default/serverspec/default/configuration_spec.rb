require 'spec_helper'

describe package('git') do
  it { should be_installed }
end

describe command("su -c 'git config --get user.name' - jenkins") do
  its(:stdout) { should match 'jenkins_git_user' }
end

describe command("su -c 'git config --get user.email' - jenkins") do
  its(:stdout) { should match 'jenkins@nowhere.com' }
end

describe file('/var/lib/jenkins/.ssh') do
  it { should be_directory }
  it { should be_mode 700 }
  it { should be_owned_by 'jenkins' }
end

describe file('/var/lib/jenkins/.ssh/known_hosts') do
  it { should be_file }
  it { should be_owned_by 'jenkins' }
  it { should be_mode 600 }
  it { should contain 'github.com' }
end

describe file('/etc/httpd/ssl/server.key') do
  it { should be_file }
  it { should be_mode 500 }
end

describe file('/etc/httpd/ssl/server.crt') do
  it { should be_file }
  it { should be_mode 500 }
end

describe cert_file('/etc/httpd/ssl/server.crt') do
  it { should be_x509 }
  it { should be_subject('/CN=www.somebody.com/O=someorg/C=US/ST=MD/L=somecity') }
end
