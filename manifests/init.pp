$extlookup_datadir = "/etc/puppet/config"
$extlookup_precedence = [ "common" ]

exec { 'apt_update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

exec { 'puppet_composer':
  command => 'git submodule add git://github.com/tPl0ch/puppet-composer.git modules/composer',
  path    => '/usr/bin'
}


include git
include nginx
include php5
include mysql
include symfony2
include nginx::symfony2
include php5::symfony2
