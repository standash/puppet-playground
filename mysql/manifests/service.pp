class mysql::service {

    service {'mysqld':
        ensure => running,
        enable => true,
    }
}
