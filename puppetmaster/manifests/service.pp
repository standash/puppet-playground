class puppetmaster::service {
    service {'puppetserver':
        ensure => running,
        enable => true,
    }
}
