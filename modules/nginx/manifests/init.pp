# Install Apache

class nginx {

  package { 'nginx':
    ensure => present,
  }

  service { 'nginx':
    ensure  => running,
    require => Package['nginx']
  }

  file { '/etc/nginx/nginx.conf':
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => '/etc/puppet/modules/nginx/files/nginx.default',
    require => Package['nginx'],
    notify => Service['nginx']
  }

  file { '/etc/nginx/fastcgi_params':
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => '/etc/puppet/modules/nginx/files/fastcgi_params',
    require => Package['nginx'],
    notify => Service['nginx']
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
    require => Package['nginx']
  }

}

class nginx::symfony2 {
  include symfony2
  include nginx
  
  $symfony2_dir = extlookup('symfony2-dir', '/opt')
  $server_names = extlookup("symfony2-server-names", "symfony2")

  file { '/etc/nginx/sites-enabled/symfony2.conf':
    content => template("nginx/symfony2.conf.erb"),
    require => File['/etc/nginx/nginx.conf'],
    notify => Service['nginx']
  }
}
