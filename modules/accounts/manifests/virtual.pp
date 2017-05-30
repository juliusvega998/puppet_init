define accounts::virtual ($uid, $realname, $pass) {

	package { 'vim':  ensure => 'installed' }
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
}

