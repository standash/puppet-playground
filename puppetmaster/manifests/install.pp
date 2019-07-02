class puppetmaster::install {
	package {'puppetserver':
		ensure => installed,
	}

    package {'hiera-eyaml':
        provider => gem,
        ensure => installed,
        require => Package['puppetserver']
    }

    exec {'puppetserver-hiera-eyaml':
        path => '/usr/bin',
        command => 'puppetserver gem install hiera-eyaml',
        require => Package['hiera-eyaml']
    }
}
