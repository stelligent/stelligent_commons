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

  attr_reader :cidr_block

  attr_reader :nat_instance_type, :nat_key_pair_name

  attr_reader :bastion_ami, :allowed_ssh_source_ips, :bastion_key_pair_name, :bastion_instance_type

  attr_reader :azs_to_distribute_across

  attr_reader :vpn_gateway_name

  attr_accessor :private_subnets, :public_subnets, :natted_subnets

  def add_vpg(vpn_gateway_name:)
    deny_nil(vpn_gateway_name)

    @vpn_gateway_name = vpn_gateway_name
  end

  def add_nat(nat_instance_type:, nat_key_pair_name:)
    deny_nil(nat_instance_type, nat_key_pair_name)

    @nat_instance_type = nat_instance_type
    @nat_key_pair_name = nat_key_pair_name
  end

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

  def deny_nil(*args)
    raise ArgumentError unless args.all? { |arg| not arg.nil? }
  end
end