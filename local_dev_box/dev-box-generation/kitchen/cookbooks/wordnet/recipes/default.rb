#
# Cookbook Name:: wordnet
# Recipe:: default
#
#
# Public domain
#
# This project is in the worldwide public domain.
#
# This project is in the public domain within the United States, 
# and copyright and related rights in the work worldwide are waived 
# through the CC0 1.0 Universal public domain dedication.
#
# All contributions to this project will be released under the CC0 dedication. 
# By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
#


gem_package "rwordnet" do
  action :install
end

cookbook_file "/var/lib/wn_s.pl" do
  source "wn_s.pl"
  mode "0644"
  action :create
end
