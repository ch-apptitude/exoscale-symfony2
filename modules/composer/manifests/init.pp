class composer { 
	package { 'composer':
	  command_name => 'composer',
	  target_dir   => '/usr/local/bin',
	  auto_update => true
	}
}