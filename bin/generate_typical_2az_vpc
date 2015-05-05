#!/usr/bin/env ruby

require 'trollop'

opts = Trollop::options do
  opt :ip_to_allow_to_bastion, 'IP address of host to allow SSH access to the bastion', :type => :string, :required => true
  opt :nat_keypair_name, 'The name of the key pair to assign to the NAT instance', :type => :string, :default => 'nat_keypair', :required => false
  opt :bastion_keypair_name, 'The name of the key pair to assign to the bastion instance', :type => :string, :default => 'bastion_keypair', :required => false
end

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'vpc_description'
require 'vpc_cfn_generator'

vpc_description = VpcDescription.new(cidr_block: '192.168.0.0/16',
                                     azs_to_distribute_across: %w{us-east-1b us-east-1c})

vpc_description.public_subnets = [
  { cidr_block: '192.168.10.0/24'},
  { cidr_block: '192.168.11.0/24'}
]

vpc_description.add_nat(nat_key_pair_name: opts[:nat_keypair_name],
                        nat_instance_type: 't2.small',
                        natted_subnets:[
                          { cidr_block: '192.168.20.0/24'},
                          { cidr_block: '192.168.21.0/24'}
                        ])

vpc_description.add_bastion(bastion_key_pair_name: opts[:bastion_keypair_name],
                            bastion_instance_type: 't2.small',
                            bastion_ami: 'ami-b66ed3de',
                            allowed_ssh_source_ips: [opts[:ip_to_allow_to_bastion]])


VpcCfnGenerator.new.emit vpc_description, $stdout
