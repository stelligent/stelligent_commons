
#
# This object contains parameters that can be used to control
# the creation of an AWS VPC.
#
# Perhaps think of this object as a way to bundle up the kind
# of information one might encode in the Parameters and Mappings
# section of a CloudFormation template that would create a given VPC.
#
class VpcDescription

  def initialize(cidr_block:, azs_to_distribute_across:)
    @private_subnets = []
    @public_subnets = []
    @natted_subnets = []
    @azs_to_distribute_across = []
    @vpn_gateway_name = nil

    @cidr_block = cidr_block
    @azs_to_distribute_across = azs_to_distribute_across
  end

  #
  # String like '0.0.0.0/0'
  #
  attr_reader :cidr_block

  #
  # String like t2.small, m3.medium, etc.
  #
  attr_reader :nat_instance_type

  #
  # Arbitrary String that contains an EC2 key pair to be used to access a created NAT box
  # If no nat is "added" this will be nil
  # If this doesn't match an existing EC2 key pair then the template created by the emitter will fail.
  #
  attr_reader :nat_key_pair_name

  attr_reader :bastion_ami, :allowed_ssh_source_ips, :bastion_key_pair_name, :bastion_instance_type

  #
  # Array of strings like %w{us-east-1a us-east-1b}
  # The emitted VPC will try to balance subnets across these availability zones
  #
  attr_reader :azs_to_distribute_across

  #
  # Arbitrary String for a name for a VPN gateway (its tag Name:)
  #
  attr_reader :vpn_gateway_name

  attr_reader :private_subnets, :natted_subnets

  #
  # Array of hash objects where each hash represents a public subnet and its cidr_block like:
  #
  # [ { cidr_block: '192.168.10.0/24'}, { cidr_block: '192.168.11.0/24'} ]
  #
  attr_accessor  :public_subnets

  #
  # add N private subnets, and a VPG that will route them using propagation
  #
  def add_vpg(vpn_gateway_name:, private_subnets:)
    deny_nil(vpn_gateway_name, private_subnets)

    @vpn_gateway_name = vpn_gateway_name
    @private_subnets = private_subnets
  end

  #
  # add a single NAT instance and route the specified subnets to it
  # if there is a nat then there must be at least > 0 public subnets
  #
  def add_nat(nat_instance_type:, nat_key_pair_name:, natted_subnets:)
    deny_nil(nat_instance_type, nat_key_pair_name)

    @nat_instance_type = nat_instance_type
    @nat_key_pair_name = nat_key_pair_name
    @natted_subnets = natted_subnets
  end

  #
  # add a single bastion instance to the VPC
  # if there is a bastion then there must be at least > 0 public subnets
  #
  def add_bastion(bastion_ami:, allowed_ssh_source_ips:, bastion_key_pair_name:, bastion_instance_type:)
    deny_nil(bastion_ami, allowed_ssh_source_ips, bastion_key_pair_name, bastion_key_pair_name)

    @bastion_ami = bastion_ami
    @allowed_ssh_source_ips = allowed_ssh_source_ips
    @bastion_key_pair_name = bastion_key_pair_name
    @bastion_instance_type = bastion_instance_type
  end

  def add_openvpn_server
    raise 'not implemented yet!!!!'
  end

  #
  # encapsulate any validation among the different pieces
  # of info in this DTOish object
  #
  def validate
    if not @vpn_gateway_name.nil? and @private_subnets.size == 0
      raise 'vpn gateway requires private subnets'
    end

    if @nat_instance_type.nil? and @public_subnets.size == 0
      raise 'nat requires public subnets'
    end

    if @bastion_instance_type.nil? and @public_subnets.size == 0
      raise 'nat requires public subnets'
    end
  end

  private

  def deny_nil(*args)
    raise ArgumentError unless args.all? { |arg| not arg.nil? }
  end
end