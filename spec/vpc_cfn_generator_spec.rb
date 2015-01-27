require 'json'
require 'vpc_description'
require 'vpc_cfn_generator'

describe 'vpc_cfn_generator' do

  before(:all) do
    @vpc_description = VpcDescription.new(cidr_block: '192.168.0.0/16',
                                          azs_to_distribute_across: %w{us-east-1b us-east-1c})
  end

  def emit_json_output(vpc_description)
    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output

    JSON.parse(output.string)
  end

  it 'generates a vpc cfn template with a specific cidr mask and 0 public subnets' do
    json_output = emit_json_output(@vpc_description)
    expect(json_output['Resources']['InternetGateway']).to eq nil
  end

  it 'generates a vpc cfn template with a specific cidr mask and 2 public subnets' do
    @vpc_description.public_subnets = [
      { cidr_block: '192.168.10.0/24'},
      { cidr_block: '192.168.11.0/24'}
    ]

    json_output = emit_json_output(@vpc_description)

    expect(json_output['Resources']['InternetGateway']['Type']).to eq 'AWS::EC2::InternetGateway'
    expect(json_output['Resources']['PublicSubnet0']['Properties']['CidrBlock']).to eq '192.168.10.0/24'
    expect(json_output['Resources']['PublicSubnet1']['Properties']['CidrBlock']).to eq '192.168.11.0/24'
  end

  it 'generates a vpc cfn template with a specific cidr mask and 2 public subnets and 2 natted subnets' do
    @vpc_description.public_subnets = [
      { cidr_block: '192.168.10.0/24'},
      { cidr_block: '192.168.11.0/24'}
    ]

    @vpc_description.add_nat(nat_key_pair_name: 'nat_keypair',
                             nat_instance_type: 'm1.small',
                             natted_subnets: [
                               { cidr_block: '192.168.20.0/24'},
                               { cidr_block: '192.168.21.0/24'}
                             ])

    json_output = emit_json_output(@vpc_description)

    expect(json_output['Resources']['InternetGateway']['Type']).to eq 'AWS::EC2::InternetGateway'
    expect(json_output['Resources']['NattedSubnet0']['Properties']['CidrBlock']).to eq '192.168.20.0/24'
    expect(json_output['Resources']['NattedSubnet1']['Properties']['CidrBlock']).to eq '192.168.21.0/24'

    expect(json_output['Resources']['NattedRouteTable']).not_to eq nil
    expect(json_output['Resources']['NAT']).not_to eq nil
  end

  it 'generates a vpc cfn template with a specific cidr mask and 3 public subnets and 3 natted subnets' do

  end

  it 'generates a vpc cfn template with a specific cidr mask and 2 private subnets and a gw with route propagation' do

  end
end