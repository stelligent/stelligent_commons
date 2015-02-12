name "passenger_nginx"
maintainer "Stelligent"
maintainer_email "jason.blalock@excella.com"
description "Installs passenger nginx"
version "0.1.0"

supports "ubuntu", "~> 14.04.0"

depends "apt"

recipe "passenger_nginx::default", "Installs passenger for nginx"
