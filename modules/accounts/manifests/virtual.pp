define accounts::virtual ($uid, $realname, $pass, $email) {

	package { 'vim-minimal':  ensure => 'installed' }
	package { 'curl': ensure => 'installed' }
	package { 'git':  ensure => 'installed' }

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

	file { "/home/${title}/scripts":
		ensure		=> directory,
	}

	file { "/home/${title}/src/":
		ensure		=> directory,
	}

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

	exec { 'soft_link_script':
		command		=> "ln -s /home/${title}/scripts/memory_check.sh /home/${title}/src/my_memory_check",
		path		=> '/bin',
	}

	cron { 'memory_check':
		command		=> "./home/${titlle}/src/my_memory_check -c 90 -w 60 -e ${email}",
		user		=> $title,
		hour		=> 0,
		minute		=> 10,
	}
}

