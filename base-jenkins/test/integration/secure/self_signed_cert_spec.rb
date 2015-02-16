require 'spec_helper'

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

