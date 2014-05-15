$extlookup_datadir = "/etc/puppet/config"
$extlookup_precedence = [ "common" ]

exec { 'apt_update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

include git
include nginx
include php5
include mysql
include composer
include symfony2
include nginx::symfony2
include php5::symfony2
