require 'spec_helper'

#hmmm this is ubuntu specific perhaps?
describe package('lxc-docker') do
  it { should be_installed.with_version('1.5.0') }
end