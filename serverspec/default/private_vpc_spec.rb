require_relative 'spec_helper'


describe 'private network with VPN connection through Virtual Private Gateway', :private do

  vpc_id = ENV['VPC_ID']

  describe vpc(vpc_id), :vpg do
    its(:virtual_private_gateway) { should have_name('dummygw') }
  end


  describe vpc(vpc_id), :basics do
    it { should be_default_tenancy }

    it { should be_available }

    its(:cidr_block) { should eq '192.168.0.0/16' }

    its(:dhcp_options) {
      should include({:domain_name=>'ec2.internal'})
      should include({:domain_name_servers=>%w{AmazonProvidedDNS}})
      should_not include :netbios_node_type
      should_not include :netbios_name_servers
      should_not include :ntp_servers

      should have_exactly(2).options
    }
  end

  describe vpc(vpc_id), :gateways do
    it { should_not be_attached_to_an_internet_gateway }

    it { should be_attached_to_an_virtual_private_gateway }

    its(:virtual_private_gateway) { should have_name('dummygw')}
  end

  describe vpc(vpc_id), :subnets_and_routing do
    it {
      should have_exactly(2).subnets
    }

    its(:subnets) {
      should have_cidr_blocks %w{192.168.10.0/24 192.168.11.0/24}
    }

    its(:public_subnets) {
      should have_exactly(0).subnets
    }
    its(:natted_subnets) {
      should have_exactly(0).subnets
    }

    its(:private_subnets) {
      should have_exactly(2).subnets
      should be_evenly_split_across_az(2)
    }

    its(:network_acls) { should have_default_rules }
  end

  describe vpc(vpc_id), :nats do
    its(:nats) { should have_exactly(0).nat }
  end

  describe vpc(vpc_id), :bastion do
    its(:public_non_nat_ec2_instances) { should have_exactly(0).instance }
  end
end

