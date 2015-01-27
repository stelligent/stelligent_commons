class VpcDescription

  def initialize
    @nat_ingress_rules = []
    @nat_egress_rules = []
    @private_subnets = []
    @public_subnets = []
    @natted_subnets = []
  end

  attr_accessor :private_subnets, :public_subnets, :natted_subnets

  attr_accessor :cidr_block

  attr_accessor :nat_instance_type, :nat_key_pair_name

  attr_accessor :bastion_ami, :allowed_ssh_source_ips, :bastion_key_pair_name, :bastion_instance_type

  attr_accessor :azs_to_distribute_across

  attr_accessor :vpn_gateway_name
end