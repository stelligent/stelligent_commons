require 'vpc_description'
require 'vpc_cfn_generator'
require 'cfn_executor'

describe 'manual test driver'  do
  it 'creates a private vpc', :private do
    vpc_description = VpcDescription.new(cidr_block: '192.168.0.0/16',
                                         azs_to_distribute_across: %w{us-east-1b us-east-1c})

    vpc_description.add_vpg(vpn_gateway_name: 'dummygw',
                            private_subnets: [
                              { cidr_block: '192.168.10.0/24'},
                              { cidr_block: '192.168.11.0/24'}
                            ])

    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output
    output.rewind

    CloudFormationExecutor.new.execute 'private-vpc-with-vpg', output
  end
end

