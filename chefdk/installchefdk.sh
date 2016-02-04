#!/usr/bin/env bash
set -e

# Based on https://gist.github.com/vpack/7a9d19aff6a785e0ea50
# Installs ChefDK (and Berks) on Amazon Linux
curl -L https://www.opscode.com/chef/install.sh | bash
rpm -Uvh https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.4.0-1.x86_64.rpm

mkdir /var/chef
cd /var/chef
yum -y install git

# knife cookbook site download apache2
# tar -zxvf apache2-3.0.1.tar.gz
cat > metadata.rb <<EOF
name 'my-wiki'
EOF

cat > Berksfile << EOF
source 'https://supermarket.chef.io'
cookbook 'mysql-chef_gem', '= 0.0.5'
cookbook 'mediawiki'