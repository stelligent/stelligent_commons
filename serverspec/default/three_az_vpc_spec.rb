require_relative 'spec_helper'

describe 'the three az network', :three_az do

  vpc_id = ENV['VPC_ID']

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
    it { should be_attached_to_an_internet_gateway }

    it { should_not be_attached_to_an_virtual_private_gateway }
  end

  describe vpc(vpc_id), :subnets_and_routing do
    it {
      should have_exactly(6).subnets
    }

    its(:subnets) {
      should have_cidr_blocks %w{192.168.10.0/24 192.168.11.0/24 192.168.12.0/24 192.168.20.0/24 192.168.21.0/24 192.168.22.0/24}
    }

    its(:public_subnets) {
      should have_exactly(3).subnets

      should have_cidr_blocks %w{192.168.10.0/24 192.168.11.0/24 192.168.12.0/24}

      should be_evenly_split_across_az(3)
    }
    its(:natted_subnets) {
      should have_exactly(3).subnets

      should have_cidr_blocks %w{192.168.20.0/24 192.168.21.0/24 192.168.22.0/24}

      should be_evenly_split_across_az(3)
    }

    its(:private_subnets) { should have_exactly(0).subnets }

    its(:network_acls) { should have_default_rules }

  end

  describe vpc(vpc_id), :nats do
    its(:nats) { should have_exactly(1).nat }

    its(:nats) { should all have_source_dest_checking_disabled }

    its(:nats) { should all have_elastic_ip }

    its(:nats) {
      should all have_ingress_rules [
                                      {:port_range=>80..80, :protocol=>:tcp, :ip_ranges=>%w{192.168.0.0/16}},
                                      {:port_range=>443..443, :protocol=>:tcp, :ip_ranges=>%w{192.168.0.0/16}},
                                      {:port_range=>11371..11371, :protocol=>:tcp, :ip_ranges=>%w{192.168.0.0/16}}
                                    ]
    }

    its(:nats) {
      should all have_egress_rules [
                                     {:port_range=>80..80, :protocol=>:tcp, :ip_ranges=>%w{0.0.0.0/0}},
                                     {:port_range=>443..443, :protocol=>:tcp, :ip_ranges=>%w{0.0.0.0/0}},
                                     {:port_range=>11371..11371, :protocol=>:tcp, :ip_ranges=>%w{0.0.0.0/0}}
                                   ]
    }
  end

  describe vpc(vpc_id), :bastion do
    its(:public_non_nat_ec2_instances) { should have_exactly(1).instance }
    its(:public_non_nat_ec2_instances) {
      ENV['BASTION_INGRESS'].should_not eq nil
      ip_addresses_with_bastion_access = ENV['BASTION_INGRESS'].split(',')

      should all have_ingress_rules [
                                      {:port_range=>22..22, :protocol=>:tcp, :ip_ranges=>ip_addresses_with_bastion_access.map{|ip| "#{ip}/32"}}
                                    ]
      should all have_egress_rules [
                                     {:port_range=>22..22, :protocol=>:tcp, :ip_ranges=>%w{192.168.0.0/16}},
                                     {:port_range=>80..80, :protocol=>:tcp, :ip_ranges=>%w{0.0.0.0/0}},
                                     {:port_range=>443..443, :protocol=>:tcp, :ip_ranges=>%w{0.0.0.0/0}},
                                     {:port_range=>11371..11371, :protocol=>:tcp, :ip_ranges=>%w{0.0.0.0/0}}
                                   ]
    }
  end
end