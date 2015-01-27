require 'erb'
require 'JSON'

class VpcCfnGenerator

  def emit(vpc_description, io)
    @cfn_template = Hash.new

    emit_headers
    emit_mappings
    emit_resources vpc_description

    io.write JSON.pretty_generate(@cfn_template)
  end

  private

  def emit_headers
    @cfn_template['AWSTemplateFormatVersion'] = '2010-09-09'
    @cfn_template['Description'] = 'Template to create a basic VPC'
  end

  def emit_mappings
    @cfn_template['Mappings'] = Hash.new
  end

  def emit_resources(vpc_description)
    @cfn_template['Resources'] = Hash.new

    emit_vpc vpc_description
    emit_internet_gateway vpc_description
    emit_public_subnets vpc_description
    emit_natted_subnets vpc_description
    emit_private_subnets vpc_description
    emit_bastion vpc_description
  end

  def define_nat_sg_rules(vpc_description)
    @nat_ingress_rules = [
      {:port_range=>80..80, :protocol=>:tcp, :cidr_ip=>vpc_description.cidr_block},
      {:port_range=>443..443, :protocol=>:tcp, :cidr_ip=>vpc_description.cidr_block},
      {:port_range=>11371..11371, :protocol=>:tcp, :cidr_ip=>vpc_description.cidr_block}
    ]

    @nat_egress_rules = [
      {:port_range=>80..80, :protocol=>:tcp, :cidr_ip=>'0.0.0.0/0'},
      {:port_range=>443..443, :protocol=>:tcp, :cidr_ip=>'0.0.0.0/0'},
      {:port_range=>11371..11371, :protocol=>:tcp, :cidr_ip=>'0.0.0.0/0'}
    ]
  end

  def define_bastion_sg_rules(vpc_description)
    @bastion_ingress_rules = vpc_description.allowed_ssh_source_ips.map do |ip|
      {:port_range=>22..22, :protocol=>:tcp, :cidr_ip=>"#{ip}/32"}
    end

    @bastion_egress_rules = [
      {:port_range=>22..22, :protocol=>:tcp, :cidr_ip=>vpc_description.cidr_block},
      {:port_range=>80..80, :protocol=>:tcp, :cidr_ip=>'0.0.0.0/0'},
      {:port_range=>443..443, :protocol=>:tcp, :cidr_ip=>'0.0.0.0/0'},
      {:port_range=>11371..11371, :protocol=>:tcp, :cidr_ip=>'0.0.0.0/0'}
    ]
  end

  def emit_vpc(vpc_description)
    @cfn_template['Resources']['VPC'] =  {
      'Type' => 'AWS::EC2::VPC',
      'Properties' => {
        'CidrBlock' => vpc_description.cidr_block
      }
    }
  end

  def ref(name)
    { 'Ref' => name }
  end



  def emit_nat_eip
    @cfn_template['Resources']['NATIPAddress'] = {
      'Type' => 'AWS::EC2::EIP',
      'DependsOn' => 'InternetGateway',
      'Properties' => {
        'Domain' => 'vpc',
        'InstanceId' => ref('NAT')
       }
    }
  end

  def emit_bastion_eip
    @cfn_template['Resources']['BastionIPAddress'] = {
      'Type' => 'AWS::EC2::EIP',
      'DependsOn' => 'InternetGateway',
      'Properties' => {
        'Domain' => 'vpc',
        'InstanceId' => ref('Bastion')
      }
    }
  end

  def emit_nat_ami_mappings

    @cfn_template['Mappings']['AWSRegionArch2AMI'] = {
      'us-east-1'      => { 'PV64' => 'ami-50842d38', 'HVM64' => 'ami-08842d60', 'HVMG2' => 'ami-3a329952'  },
      'us-west-2'      => { 'PV64' => 'ami-af86c69f', 'HVM64' => 'ami-8786c6b7', 'HVMG2' => 'ami-47296a77'  },
      'us-west-1'      => { 'PV64' => 'ami-c7a8a182', 'HVM64' => 'ami-cfa8a18a', 'HVMG2' => 'ami-331b1376'  },
      'eu-west-1'      => { 'PV64' => 'ami-aa8f28dd', 'HVM64' => 'ami-748e2903', 'HVMG2' => 'ami-00913777'  },
      'ap-southeast-1' => { 'PV64' => 'ami-20e1c572', 'HVM64' => 'ami-d6e1c584', 'HVMG2' => 'ami-fabe9aa8'  },
      'ap-northeast-1' => { 'PV64' => 'ami-21072820', 'HVM64' => 'ami-35072834', 'HVMG2' => 'ami-5dd1ff5c'  },
      'ap-southeast-2' => { 'PV64' => 'ami-8b4724b1', 'HVM64' => 'ami-fd4724c7', 'HVMG2' => 'ami-e98ae9d3'  },
      'sa-east-1'      => { 'PV64' => 'ami-9d6cc680', 'HVM64' => 'ami-956cc688', 'HVMG2' => 'NOT_SUPPORTED' },
      'cn-north-1'     => { 'PV64' => 'ami-a857c591', 'HVM64' => 'ami-ac57c595', 'HVMG2' => 'NOT_SUPPORTED' },
      'eu-central-1'   => { 'PV64' => 'ami-a03503bd', 'HVM64' => 'ami-b43503a9', 'HVMG2' => 'ami-b03503ad'  }
    }

    @cfn_template['Mappings']['AWSNATInstanceType2Arch'] = {
      't1.micro'    => { 'Arch' => 'PV64'   },
      't2.micro'    => { 'Arch' => 'HVM64'  },
      't2.small'    => { 'Arch' => 'HVM64'  },
      't2.medium'   => { 'Arch' => 'HVM64'  },
      'm1.small'    => { 'Arch' => 'PV64'   },
      'm1.medium'   => { 'Arch' => 'PV64'   },
      'm1.large'    => { 'Arch' => 'PV64'   },
      'm1.xlarge'   => { 'Arch' => 'PV64'   },
      'm2.xlarge'   => { 'Arch' => 'PV64'   },
      'm2.2xlarge'  => { 'Arch' => 'PV64'   },
      'm2.4xlarge'  => { 'Arch' => 'PV64'   },
      'm3.medium'   => { 'Arch' => 'HVM64'  },
      'm3.large'    => { 'Arch' => 'HVM64'  },
      'm3.xlarge'   => { 'Arch' => 'HVM64'  },
      'm3.2xlarge'  => { 'Arch' => 'HVM64'  },
      'c1.medium'   => { 'Arch' => 'PV64'   },
      'c1.xlarge'   => { 'Arch' => 'PV64'   },
      'c3.large'    => { 'Arch' => 'HVM64'  },
      'c3.xlarge'   => { 'Arch' => 'HVM64'  },
      'c3.2xlarge'  => { 'Arch' => 'HVM64'  },
      'c3.4xlarge'  => { 'Arch' => 'HVM64'  },
      'c3.8xlarge'  => { 'Arch' => 'HVM64'  },
      'r3.large'    => { 'Arch' => 'HVM64'  },
      'r3.xlarge'   => { 'Arch' => 'HVM64'  },
      'r3.2xlarge'  => { 'Arch' => 'HVM64'  },
      'r3.4xlarge'  => { 'Arch' => 'HVM64'  },
      'r3.8xlarge'  => { 'Arch' => 'HVM64'  },
      'i2.xlarge'   => { 'Arch' => 'HVM64'  },
      'i2.2xlarge'  => { 'Arch' => 'HVM64'  },
      'i2.4xlarge'  => { 'Arch' => 'HVM64'  },
      'i2.8xlarge'  => { 'Arch' => 'HVM64'  },
      'hi1.4xlarge' => { 'Arch' => 'PV64'   },
      'hs1.8xlarge' => { 'Arch' => 'HVM64'  },
      'cr1.8xlarge' => { 'Arch' => 'HVM64'  },
      'cc2.8xlarge' => { 'Arch' => 'HVM64'  }
    }

    @cfn_template['Mappings']['AWSNATRegionArch2AMI'] = {
      'us-east-1'      => { 'PV64' => 'ami-809f4ae8', 'HVM64' => 'ami-4c9e4b24',  'HVMG2' => 'ami-6e9e4b06'  },
      'us-west-2'      => { 'PV64' => 'ami-49691279', 'HVM64' => 'ami-bb69128b',  'HVMG2' => 'ami-8b6912bb'  },
      'us-west-1'      => { 'PV64' => 'ami-7d2b2938', 'HVM64' => 'ami-2b2b296e',  'HVMG2' => 'ami-1d2b2958'  },
      'eu-west-1'      => { 'PV64' => 'ami-6d60b01a', 'HVM64' => 'ami-3760b040',  'HVMG2' => 'ami-5b60b02c'  },
      'ap-southeast-1' => { 'PV64' => 'ami-d282da80', 'HVM64' => 'ami-b082dae2',  'HVMG2' => 'ami-d482da86'  },
      'ap-northeast-1' => { 'PV64' => 'ami-31c29e30', 'HVM64' => 'ami-55c29e54',  'HVMG2' => 'ami-49c29e48'  },
      'ap-southeast-2' => { 'PV64' => 'ami-b564028f', 'HVM64' => 'ami-996402a3',  'HVMG2' => 'ami-a164029b'  },
      'sa-east-1'      => { 'PV64' => 'ami-9972db84', 'HVM64' => 'ami-b972dba4',  'HVMG2' => 'NOT_SUPPORTED' },
      'cn-north-1'     => { 'PV64' => 'ami-eab220d3', 'HVM64' => 'NOT_SUPPORTED', 'HVMG2' => 'NOT_SUPPORTED' },
      'eu-central-1'   => { 'PV64' => 'ami-6c487e71', 'HVM64' => 'ami-204c7a3d',  'HVMG2' => 'ami-5c4c7a41' }
    }
  end

  def nat_security_group(vpc_description)
    {
      'DependsOn' => %w{VPC},
      'Type' => 'AWS::EC2::SecurityGroup',
      'Properties' => {
        'GroupDescription' => 'NAT Security Group',
        'VpcId' => ref('VPC'),
        'SecurityGroupIngress' => ip_permissions(@nat_ingress_rules),
        'SecurityGroupEgress' => ip_permissions(@nat_egress_rules)
      }
    }
  end

  def bastion_security_group(vpc_description)
    {
      'DependsOn' => %w{VPC},
      'Type' => 'AWS::EC2::SecurityGroup',
      'Properties' => {
        'GroupDescription' => 'Bastion Security Group',
        'VpcId' => ref('VPC'),
        'SecurityGroupIngress' => ip_permissions(@bastion_ingress_rules),
        'SecurityGroupEgress' => ip_permissions(@bastion_egress_rules)
      }
    }
  end

  def ip_permissions(permissions)
    permissions.map do |permission|
      {
        'IpProtocol' => permission[:protocol],
        'FromPort' => permission[:port_range].begin,
        'ToPort' => permission[:port_range].end,
        'CidrIp' => permission[:cidr_ip]
      }
    end
  end

  def emit_nat(vpc_description)
    emit_nat_ami_mappings

    @cfn_template['Resources']['NatSecurityGroup'] = nat_security_group vpc_description

    @cfn_template['Resources']['NAT'] = {
      'DependsOn' => %w{PublicSubnet0 NatSecurityGroup},
      'Type' => 'AWS::EC2::Instance',
      'Properties' =>  {
        'InstanceType' => vpc_description.nat_instance_type,
        'KeyName' =>  vpc_description.nat_key_pair_name,
        'SourceDestCheck' => 'false',
        'ImageId' => {
          'Fn::FindInMap' => [
            'AWSNATRegionArch2AMI',
            ref('AWS::Region'),
            { 'Fn::FindInMap' => [ 'AWSNATInstanceType2Arch', vpc_description.nat_instance_type, 'Arch' ]}
          ]
        },
        'NetworkInterfaces' => [
          {
            'GroupSet' => [ref('NatSecurityGroup')],
            'AssociatePublicIpAddress' => 'true',
            'DeviceIndex' => '0',
            'DeleteOnTermination' => 'true',
            'SubnetId' => ref('PublicSubnet0')
          }
        ]
      }
    }

    emit_nat_eip
  end

  def emit_bastion(vpc_description)
    if not vpc_description.bastion_ami.nil?
      define_bastion_sg_rules vpc_description

      @cfn_template['Resources']['BastionSecurityGroup'] = bastion_security_group vpc_description

      @cfn_template['Resources']['Bastion'] = {
        'DependsOn' => %w{PublicSubnet0 BastionSecurityGroup},
        'Type' => 'AWS::EC2::Instance',
        'Properties' =>  {
          'InstanceType' => vpc_description.bastion_instance_type,
          'KeyName' =>  vpc_description.bastion_key_pair_name,
          'ImageId' => vpc_description.bastion_ami,
          'SecurityGroupIds' => [ref('BastionSecurityGroup')],
          'SubnetId' => ref('PublicSubnet0')
        }
      }

      emit_bastion_eip
    end

  end

  def emit_natted_subnets(vpc_description)
    if vpc_description.natted_subnets.size > 0
      define_nat_sg_rules vpc_description

      emit_nat vpc_description
      @cfn_template['Resources']['NattedRouteTable'] = {
        'Type' => 'AWS::EC2::RouteTable',
        'Properties' => {
          'VpcId' => ref('VPC')
        }
      }
    end

    vpc_description.natted_subnets.each_with_index do |subnet, subnet_index|
      @cfn_template['Resources']["NattedSubnet#{subnet_index}"] = {
        'Type' => 'AWS::EC2::Subnet',
        'Properties' => {
          'VpcId' => ref('VPC'),
          'CidrBlock' => subnet[:cidr_block],
          'AvailabilityZone' => pick_az(subnet_index)
        }
      }

      @cfn_template['Resources']["Natteds#{subnet_index}Route"] = {
        'Type' => 'AWS::EC2::Route',
        'DependsOn' => 'AttachGateway',
        'Properties' => {
          'RouteTableId' => ref('NattedRouteTable'),
          'DestinationCidrBlock' =>  '0.0.0.0/0',
          'InstanceId' => ref('NAT')
        }
      }

      @cfn_template['Resources']["NattedSubnet#{subnet_index}RouteTableAssociation"] = {
        'Type' => 'AWS::EC2::SubnetRouteTableAssociation',
        'Properties' => {
          'SubnetId' => {
            'Ref' => "NattedSubnet#{subnet_index}"
          },
          'RouteTableId' => ref('NattedRouteTable')
        }
      }
    end
  end

  def subnets
    %w{us-east-1b us-east-1c us-east-1d us-east-1e}
  end

  def pick_az(subnet_index)
    subnets[subnet_index % subnets.size]
  end

  def emit_public_subnets(vpc_description)
    vpc_description.public_subnets.each_with_index do |subnet, subnet_index|
      @cfn_template['Resources']["PublicSubnet#{subnet_index}"] = {
        'Type' => 'AWS::EC2::Subnet',
        'Properties' => {
          'VpcId' => ref('VPC'),
          'CidrBlock' => subnet[:cidr_block],
          'AvailabilityZone' => pick_az(subnet_index)
        }
      }

      @cfn_template['Resources']["PublicSubnet#{subnet_index}Route"] = {
        'Type' => 'AWS::EC2::Route',
        'DependsOn' => 'AttachGateway',
        'Properties' => {
          'RouteTableId' => {
            'Ref' => 'PublicRouteTable'
          },
          'DestinationCidrBlock' =>  '0.0.0.0/0',
          'GatewayId' =>  {
            'Ref' => 'InternetGateway'
          }
        }
      }

      @cfn_template['Resources']["PublicSubnet#{subnet_index}RouteTableAssociation"] = {
        'Type' => 'AWS::EC2::SubnetRouteTableAssociation',
        'Properties' => {
          'SubnetId' => {
            'Ref' => "PublicSubnet#{subnet_index}"
          },
          'RouteTableId' => {
            'Ref' => 'PublicRouteTable'
          }
        }
      }
    end
  end

  def emit_internet_gateway(vpc_description)
    if vpc_description.public_subnets.size > 0
      @cfn_template['Resources']['InternetGateway'] = {
        'Type' => 'AWS::EC2::InternetGateway'
      }

      @cfn_template['Resources']['AttachGateway'] = {
        'Type' => 'AWS::EC2::VPCGatewayAttachment',
        'Properties' => {
          'VpcId' => ref('VPC'),
          'InternetGatewayId' => {
            'Ref' => 'InternetGateway'
          }
        }
      }

      @cfn_template['Resources']['PublicRouteTable'] = {
        'Type' => 'AWS::EC2::RouteTable',
        'Properties' => {
          'VpcId' => ref('VPC')
        }
      }
    end
  end


  def emit_vpn_gateway(vpc_description)
    if not vpc_description.vpn_gateway_name.nil?
      @cfn_template['Resources']['VPNGateway'] = {
        'Type' => 'AWS::EC2::VPNGateway',
        'Properties' => {
          'Type' => 'ipsec.1',
          'Tags' => [ { 'Key' => 'Name', 'Value' => vpc_description.vpn_gateway_name } ]
        }
      }

      @cfn_template['Resources']['AttachVpnGateway'] = {
        'Type' => 'AWS::EC2::VPCGatewayAttachment',
        'Properties' => {
          'VpcId' => ref('VPC'),
          'VpnGatewayId' => { 'Ref' => 'VPNGateway' }
        }
      }

      @cfn_template['Resources']['VPNGatewayRouteProp'] = {
        'Type' => 'AWS::EC2::VPNGatewayRoutePropagation',
        'Properties' => {
          'RouteTableIds' => [{'Ref' => 'PrivateRouteTable'}],
          'VpnGatewayId' => { 'Ref' => 'VPNGateway' }
        }
      }
    end
  end

  def emit_private_subnets(vpc_description)
    if vpc_description.private_subnets.size > 0
      @cfn_template['Resources']['PrivateRouteTable'] = {
        'Type' => 'AWS::EC2::RouteTable',
        'Properties' => {
          'VpcId' => ref('VPC')
        }
      }
      emit_vpn_gateway vpc_description
    end

    vpc_description.private_subnets.each_with_index do |subnet, subnet_index|
      @cfn_template['Resources']["PrivateSubnet#{subnet_index}"] = {
        'Type' => 'AWS::EC2::Subnet',
        'Properties' => {
          'VpcId' => ref('VPC'),
          'CidrBlock' => subnet[:cidr_block],
          'AvailabilityZone' => pick_az(subnet_index)
        }
      }

      @cfn_template['Resources']["PrivateSubnet#{subnet_index}RouteTableAssociation"] = {
        'Type' => 'AWS::EC2::SubnetRouteTableAssociation',
        'Properties' => {
          'SubnetId' => {
            'Ref' => "PrivateSubnet#{subnet_index}"
          },
          'RouteTableId' => {
            'Ref' => 'PrivateRouteTable'
          }
        }
      }
    end
  end
end