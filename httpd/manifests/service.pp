class httpd::service {

    service {'httpd-service':
        name => 'httpd',
        enable => true,
        ensure => running,
    }
}
