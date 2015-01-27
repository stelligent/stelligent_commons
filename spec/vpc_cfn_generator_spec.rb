require 'json'
require 'vpc_description'
require 'vpc_cfn_generator'

describe 'vpc_cfn_generator' do

  it 'generates a vpc cfn template with a specific cidr mask and 0 public subnets' do

    vpc_description = VpcDescription.new
    vpc_description.cidr_block = '192.168.0.0/16'
    vpc_description.public_subnets = []

    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output

    json_output = JSON.parse(output.string)

    expect(json_output['Resources']['InternetGateway']).to eq nil
  end

  it 'generates a vpc cfn template with a specific cidr mask and 2 public subnets' do

    vpc_description = VpcDescription.new
    vpc_description.cidr_block = '192.168.0.0/16'
    vpc_description.public_subnets = [
      { cidr_block: '192.168.10.0/24'},
      { cidr_block: '192.168.11.0/24'}
    ]

    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output

    json_output = JSON.parse(output.string)

    expect(json_output['Resources']['InternetGateway']['Type']).to eq 'AWS::EC2::InternetGateway'
    expect(json_output['Resources']['PublicSubnet0']['Properties']['CidrBlock']).to eq '192.168.10.0/24'
    expect(json_output['Resources']['PublicSubnet1']['Properties']['CidrBlock']).to eq '192.168.11.0/24'
  end

  it 'generates a vpc cfn template with a specific cidr mask and 2 public subnets and 2 natted subnets' do

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
    vpc_description.nat_instance_type = 'm1.small'

    vpc_cfn_generator = VpcCfnGenerator.new
    output = StringIO.new
    vpc_cfn_generator.emit vpc_description, output

    json_output = JSON.parse(output.string)

    expect(json_output['Resources']['InternetGateway']['Type']).to eq 'AWS::EC2::InternetGateway'
    expect(json_output['Resources']['NattedSubnet0']['Properties']['CidrBlock']).to eq '192.168.20.0/24'
    expect(json_output['Resources']['NattedSubnet1']['Properties']['CidrBlock']).to eq '192.168.21.0/24'

    expect(json_output['Resources']['NattedRouteTable']).not_to eq nil
    expect(json_output['Resources']['NAT']).not_to eq nil

    puts output.string
  end
end