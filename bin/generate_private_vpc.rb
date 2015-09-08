#!/usr/bin/env ruby

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'vpc_description'
require 'vpc_cfn_generator'

vpc_description = VpcDescription.new(cidr_block: '192.168.0.0/16',
                                     azs_to_distribute_across: %w{us-east-1b us-east-1c})

vpc_description.add_vpg(vpn_gateway_name: 'dummygw',
                        private_subnets: [
                          { cidr_block: '192.168.10.0/24'},
                          { cidr_block: '192.168.11.0/24'}
                        ])


VpcCfnGenerator.new.emit vpc_description, $stdout