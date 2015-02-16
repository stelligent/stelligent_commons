require 'spec_helper'

describe file('/etc/sysconfig/jenkins') do
  it { should be_file }
  it { should be_mode 644 }
  it { should contain 'source /etc/profile' }
end