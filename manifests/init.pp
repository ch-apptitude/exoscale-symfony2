$extlookup_datadir = "/etc/puppet/config"
$extlookup_precedence = [ "common" ]

exec { 'apt_update':
  command => 'apt-get update',
  path    => '/usr/bin'
}
exec { apache_stop :
        command => '/usr/sbin/service apache2 stop' ,
        refreshonly => false , # required for when entering at exe_ln
        onlyif => "/usr/sbin/service apache2 status"
        }
exec { set_env_var :
	environment => [ "COMPOSER_HOME=/root" ] 
}

include git
include nginx
include php5
include mysql
include composer
include symfony2
include nginx::symfony2
include php5::symfony2
