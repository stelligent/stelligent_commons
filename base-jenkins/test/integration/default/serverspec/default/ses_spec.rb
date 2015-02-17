require 'spec_helper'

describe file('/etc/admin_email') do
  it { should be_file }
  it { should contain 'admin@dummyjenkins.com'}
end

describe file('/etc/sysconfig/jenkins') do
  it { should be_file }
  it { should contain '-Dmail.smtp.starttls.enable=true' }
  it { should contain 'JENKINS_HOME="/var/lib/jenkins"' }
  it { should contain 'JENKINS_USER="jenkins"' }
  it { should contain 'JENKINS_PORT="9090"'}

end

describe file('/var/lib/jenkins/hudson.plugins.emailext.ExtendedEmailPublisher.xml') do
  it { should be_file }
  it { should contain '<smtpHost>email-smtp.us-east-1.amazonaws.com</smtpHost>' }
end