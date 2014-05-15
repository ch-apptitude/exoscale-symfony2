# Install latest Wordpress

class wordpress {

  $wordpress_dir = extlookup('wordpress-dir', '/opt')
  $wordpress_db_name = extlookup('wordpress-db-name')
  $wordpress_db_user = extlookup('wordpress-db-user')
  $wordpress_db_password = extlookup('wordpress-db-password')
  $wordpress_db_rootpwd = extlookup('wordpress-db-root-password')
  $wordpress_url = extlookup('wordpress-url', 'http://wordpress.org/latest.tar.gz')
  

  # Create a directory
  file { "${wordpress_dir}":
    ensure => "directory",
  }

  # Create the Wordpress database
  exec { 'create-database':
    unless  => "/usr/bin/mysql -u root -p${wordpress_db_rootpwd} ${wordpress_db_name}",
    command => "/usr/bin/mysql -u root -p${wordpress_db_rootpwd} --execute='create database ${$wordpress_db_name}'",
  }

  # Create the Wordpress database user
  exec { 'create-user':
    command => "/usr/bin/mysql -u root -p${wordpress_db_rootpwd} --execute=\"GRANT ALL PRIVILEGES ON ${$wordpress_db_name}.* TO \'${$wordpress_db_user}\'@\'localhost\' IDENTIFIED BY \'${$wordpress_db_password}\'\"",
  }

  # Get a new copy of the latest wordpress release
  # FILE TO DOWNLOAD: http://wordpress.org/latest.tar.gz

  exec { 'download-wordpress': #tee hee
    command => '/usr/bin/wget -O "/tmp/install.tar.gz" http://wordpress.org/latest.tar.gz',
    creates => "/tmp/install.tar.gz"

  }

  exec { 'untar-wordpress':
    cwd     => $wordpress_dir,
    command => '/bin/tar xzf /tmp/install.tar.gz',
    require => Exec['download-wordpress'],
    creates => "${wordpress_dir}/wordpress",
    before => File["${wordpress_dir}/wordpress/wp-config.php"]
  }

  # Import a MySQL database for a basic wordpress site.
  file { '/tmp/wordpress-db.sql':
    ensure => file,
    path => '/tmp/wordpress-db.sql',
    content => template('wordpress/wordpress-db.sql.erb'),
    before => File["${wordpress_dir}/wordpress/wp-config.php"]
  }

  exec { 'load-db':
    command => "/usr/bin/mysql -u root -p${wordpress_db_rootpwd} ${wordpress_db_name} < /tmp/wordpress-db.sql && touch ${wordpress_dir}/wordpress/db-created",
    creates => "${wordpress_dir}/wordpress/db-created"
  }

  # Copy a working wp-config.php file for the wordpress setup.
  file { "${wordpress_dir}/wordpress/wp-config.php":
    ensure => file,
    owner   => www-data,
    content => template('wordpress/wp-config.php.erb'),
  }

}
