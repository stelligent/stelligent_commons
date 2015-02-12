#
# Cookbook Name:: pgbadger
# Recipe:: install_ppa
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
chef_gem "versionomy"

major_version = Versionomy.parse(node["libreoffice"]["version"]).major
minor_version = Versionomy.parse(node["libreoffice"]["version"]).minor

case node["platform"]
when "ubuntu"
  unless node["libreoffice"]["version"]
    return "No Libreoffice version set"
  end

  apt_repository "libreoffice-#{major_version}.#{minor_version}" do
    uri "http://ppa.launchpad.net/libreoffice/libreoffice-#{major_version}-#{minor_version}/ubuntu"
    distribution node['lsb']['codename']
    components ["main"]
    keyserver "keyserver.ubuntu.com"
    key "1378B444"
  end
end
