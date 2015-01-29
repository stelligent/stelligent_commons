require 'spec_helper'

describe jenkins_master('http://localhost:8080') do
  it { should have_plugin('scripttrigger', '0.28') }
end

