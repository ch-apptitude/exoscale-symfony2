# Install PHP

class php5 {

  package { [
      'php5',
      'php5-mysql',
      'php5-curl',
      'php5-gd',
      'php5-fpm',
      'php5-intl',
      'php5-mcrypt',
      'php5-common',
      'php5-process',
      'php-xml',
      'php-mbstring',
      'php-process',
      'php5-apcu',
      'php5-cli',
      'php-pear'
    ]:
    ensure => present,
  }
  
  service { 'php5-fpm':
    ensure  => running,
    require => Package['php5-fpm'],
  }

}

class php5::symfony2 {

  include symfony2

  $symfony2_dir = "${symfony2_dir}/symfony2"

  file { '/etc/php5/fpm/conf.d/symfony2.conf':
    content => template('php5/symfony2.conf.erb'),
    require => Package['php5-fpm'],
    notify => Service['php5-fpm']
  }
}
