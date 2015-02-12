name "libsasl2_dev"
maintainer "Excella Consulting"
maintainer_email "jason.blalock@excella.com"
description 'Installs libsasl2-dev package'
version '0.1.0'

supports "ubuntu", "~> 14.04.0"

depends 'apt'

recipe "libsasl2_dev::default", "Installs libsasl2-dev package"
