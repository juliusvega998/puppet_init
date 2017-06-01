define accounts::virtual ($uid, $realname, $pass, $email) {
	
	# install vim, curl, and git
	package { 'vim-minimal':  ensure => 'installed' }
	package { 'curl': ensure => 'installed' }
	package { 'git':  ensure => 'installed' }

	# needed for memory checker	
	package { 'bc':	  ensure => 'installed' }

	# create user based from the blog
	user { $title:
		ensure		=> 'present',
		uid		=> $uid,
		gid		=> $title,
		shell		=> '/bin/bash',
		home		=> "/home/${title}",
		comment		=> $realname,
		password	=> $pass,
		managehome	=> true,
		require		=> Group[$title],
	}

	group { $title:
		gid		=> $uid,
	}

	file { "/home/${title}":
		ensure		=> directory,
		owner		=> $title,
		group		=> $title,
		mode		=> 0750,
		require		=> [ User[$title], Group[$title] ],
	}

	# create folders
	file { "/home/${title}/scripts":
		ensure		=> directory,
	}

	file { "/home/${title}/src/":
		ensure		=> directory,
	}

	# get the memory check script and mvoe it to scripts folder
	exec { 'get_script':
		command		=> 'wget https://raw.githubusercontent.com/juliusvega998/centos_memory_checker/master/memory_check.sh',
		path 		=> '/usr/bin',
	}

	exec { 'move_script':
		command		=> "mv memory_check.sh /home/${title}/scripts/",
		path		=> '/bin',
	}

	exec { 'chomd_script':
		command		=> "chmod +x /home/${title}/scripts/memory_check.sh",
		path		=> '/bin',
	}

	# create a soft link of the script
	exec { 'soft_link_script':
		command		=> "ln -s /home/${title}/scripts/memory_check.sh /home/${title}/src/my_memory_check",
		path		=> '/bin',
	}
	
	#create a crontab entry to run the script every 10 mins
	cron { 'memory_check':
		command		=> "./home/${titlle}/src/my_memory_check -c 90 -w 60 -e ${email}",
		user		=> $title,
		hour		=> 0,
		minute		=> 10,
	}

	# set timezone to PHT
	zone { 'timezone':
		sysidcfg	=> template('accounts/sysidcfg.erb'),
	}
}

