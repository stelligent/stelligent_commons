#
# Cookbook:: cmake
# Recipe:: default
#

include_recipe "cmake::_#{node["cmake"]["install_method"]}"
