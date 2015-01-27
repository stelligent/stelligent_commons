require 'vpc_description'
require 'vpc_cfn_generator'
require 'cfn_executor'

describe 'end-to-end test' do

  it 'end-to-end' do
    vpc_description = VpcDescription.new
    vpc_description.cidr_block = '192.168.0.0/16'
    vpc_description.public_subnets = [
      { cidr_block: '192.168.10.0/24'},
      { cidr_block: '192.168.11.0/24'}
    ]

    vpc_description.natted_subnets = [
      { cidr_block: '192.168.20.0/24'},
      { cidr_block: '192.168.21.0/24'}
    ]
    vpc_description.nat_key_pair_name = 'nat_keypair'
    vpc_description.nat_instance_type = 't2.small'

    vpc_description.bastion_key_pair_name = 'bastion_keypair'
    vpc_description.bastion_instance_type = 'm1.small'
    vpc_description.bastion_ami = 'ami-b66ed3de'
    vpc_description.allowed_ssh_source_ips = %w{50.190.124.124}

    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output
    output.rewind

    success = CloudFormationExecutor.new.execute 'emk-test-stack', output
    expect(success).to eq true
  end

end