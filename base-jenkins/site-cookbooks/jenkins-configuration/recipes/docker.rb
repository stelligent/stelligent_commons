#er test this on centos

#Ubuntu Trusty 14.04 (LTS) (64-bit)
bash 'install docker from the docker repo' do
  code <<-END
    if [ ! -e /usr/lib/apt/methods/https ]; then
	    apt-get update
	    apt-get install -y apt-transport-https
    fi

    # Add the repository to your APT sources
    echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list

    # Then import the repository key
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

    # Install docker
    apt-get update
    apt-get install -y lxc-docker-1.5.0
  END
  only_if { node['platform'] == 'ubuntu' }
end
