require 'vpc_description'
require 'vpc_cfn_generator'
require 'cfn_executor'

describe 'manual test driver'  do
  it 'creates a default vpc', :default do
    vpc_description = VpcDescription.new(cidr_block: '192.168.0.0/16',
                                         azs_to_distribute_across: %w{us-east-1b us-east-1c})

    vpc_description.public_subnets = [
      { cidr_block: '192.168.10.0/24'},
      { cidr_block: '192.168.11.0/24'}
    ]

    vpc_description.natted_subnets = [
      { cidr_block: '192.168.20.0/24'},
      { cidr_block: '192.168.21.0/24'}
    ]

    vpc_description.add_nat(nat_key_pair_name: 'nat_keypair',
                            nat_instance_type: 't2.small')

    vpc_description.add_bastion(bastion_key_pair_name: 'bastion_keypair',
                                bastion_instance_type: 't2.small',
                                bastion_ami: 'ami-b66ed3de',
                                allowed_ssh_source_ips: %w{50.190.124.124})


    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output
    output.rewind

    success = CloudFormationExecutor.new.execute 'basic-vpc', output
  end
end
