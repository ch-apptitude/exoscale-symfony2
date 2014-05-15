class symfony2 {

  $symfony2_dir         = extlookup('symfony2-dir', '/opt')
  $symfony2_db_name     = extlookup('symfony2-db-name')
  $symfony2_db_user     = extlookup('symfony2-db-user')
  $symfony2_db_password = extlookup('symfony2-db-password')
  $symfony2_db_rootpwd  = extlookup('symfony2-db-root-password')
  $symfony2_db_host     = extlookup('symfony2-db-host')
  $symfony2_locale      = extlookup('symfony2-locale')
  $symfony2_secret      = extlookup('symfony2-secret')

  # Create a directory
  file { "${symfony2_dir}":
    ensure => "directory",
  }

  # Create Capifony directory structure
  file { "${symfony2_dir}/symfony2":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/shared":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/releases":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/releases/1":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/shared/vendor":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/shared/web":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/shared/app":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/shared/app/config":
    ensure => "directory",
  }
  file { "${symfony2_dir}/symfony2/shared/app/logs":
    ensure => "directory",
  }

  # Copy composer.json file for the symfony2 setup.
  file { "${symfony2_dir}/symfony2/releases/1/composer.json":
    ensure => file,
    owner   => www-data,
    content => template('symfony2/composer.json.erb'),
  }

  # Install Symfony2 from composer
  composer::project { 'symfony2':
    project_name   => 'symfony/symfony-standard',  # REQUIRED
    target_dir     => "${symfony2_dir}/symfony2/releases/1", # REQUIRED
    version        => '2.4.*', # Some valid version string
    prefer_source  => true,
    stability      => 'dev', # Minimum stability setting
    keep_vcs       => false, # Keep the VCS information
    dev            => false, # Install dev dependencies
    user           => 'www-data', # Set the user to run as
    before         => File["${symfony2_dir}/symfony2/shared/app/config/parameters.yml"]
  }


  # Copy a working parameters.yml file for the symfony2 setup.
  file { "${symfony2_dir}/symfony2/shared/app/config/parameters.yml":
    ensure => file,
    owner   => www-data,
    content => template('symfony2/parameters.yml.erb'),
  }

  # Create symlinks
  file { "${symfony2_dir}/symfony2/current":
     ensure => 'link',
     target => "${symfony2_dir}/symfony2/releases/1",
  }

  file { "${symfony2_dir}/symfony2/current/app/config/parameters.yml":
     ensure => 'link',
     target => "${symfony2_dir}/symfony2/shared/app/config/parameters.yml",
     before => File["${symfony2_dir}/symfony2/current/app/logs"],
  }

  file { "${symfony2_dir}/symfony2/current/app/logs":
     ensure => 'link',
     target => "${symfony2_dir}/symfony2/shared/app/logs",
  }

  # Create the symfony2 database
  exec { 'create-database':
    unless  => "/usr/bin/mysql -u root -p${symfony2_db_rootpwd} ${symfony2_db_name}",
    command => "/usr/bin/mysql -u root -p${symfony2_db_rootpwd} --execute='create database ${$symfony2_db_name}'",
  }

  # Create the symfony2 database user
  exec { 'create-user':
    command => "/usr/bin/mysql -u root -p${symfony2_db_rootpwd} --execute=\"GRANT ALL PRIVILEGES ON ${$symfony2_db_name}.* TO \'${$symfony2_db_user}\'@\'localhost\' IDENTIFIED BY \'${$symfony2_db_password}\'\"",
  }
}
