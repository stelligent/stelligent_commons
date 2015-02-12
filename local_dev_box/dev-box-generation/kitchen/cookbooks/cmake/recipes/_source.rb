#
# Cookbook:: cmake
# Recipe:: _source
#

include_recipe "build-essential" # ~FC007 uses `suggests`

cache_dir = Chef::Config[:file_cache_path]
cmake_version = node["cmake"]["source"]["version"]

remote_file "#{cache_dir}/cmake-#{cmake_version}.tar.gz" do
  source "http://www.cmake.org/files/v#{cmake_version[/^\d\.\d/, 0]}/cmake-#{cmake_version}.tar.gz" # rubocop:disable LineLength
  checksum node["cmake"]["source"]["checksum"]
  notifies :run, "execute[unpack cmake]"
end

execute "unpack cmake" do
  command "tar xzvf cmake-#{cmake_version}.tar.gz"
  cwd cache_dir
  notifies :run, "execute[configure cmake]"
  notifies :run, "execute[make cmake]"
  notifies :run, "execute[make install cmake]"
  action :nothing
end

execute "configure cmake" do
  command "./configure"
  cwd "#{cache_dir}/cmake-#{cmake_version}"
  action :nothing
end

execute "make cmake" do
  command "make"
  cwd "#{cache_dir}/cmake-#{cmake_version}"
  action :nothing
end

execute "make install cmake" do
  command "make install"
  cwd "#{cache_dir}/cmake-#{cmake_version}"
  creates "/usr/local/bin/cmake"
  action :nothing
end
