class puppetmaster::install {
	package {'puppetserver':
		ensure => installed,
	}
}
