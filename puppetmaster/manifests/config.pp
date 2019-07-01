class puppetmaster::config {

   file {'/etc/puppet/hiera.yaml':
        ensure => file,
        source => 'puppet:///modules/puppetmaster/hiera.yaml',
   }
    
   file {'/etc/puppet/hieradata':
        ensure => directory,
   }

   file {'/etc/puppet/hieradata/nodes':
        ensure => directory,
        source => 'puppet:///modules/puppetmaster/nodes',
        recurse => true,
        require => File['/etc/puppet/hieradata'],
   }

   file {'/etc/puppet/hieradata/common.yaml':
        ensure => file,
        source => 'puppet:///modules/puppetmaster/common.yaml',
        require => File['/etc/puppet/hieradata'],
   }

   file {'/etc/puppet/autosign.conf':
        ensure => file,
        content => "$puppetmaster::agent_hostname",
   }

   exec {'patch_hosts':
        path => '/usr/bin',
        command => "echo \"$::ipaddress puppet\" >> /etc/hosts",
        before => Exec['generate-ca'],
   }

   file {'master-config':
        source => 'puppet:///modules/puppetmaster/puppet.conf',
        path => '/etc/puppet/puppet.conf',
        before => Exec['generate-ca'],
   }

   exec {'generate-ca':
        path => '/usr/bin',
        command => 'timeout 30 sh -c \'puppet master --verbose --no-daemonize\' --foreground',
        returns => [0,124],
   }

   exec {'firewall-open-port':
         path => '/usr/bin',
         command => 'firewall-cmd --zone=public --add-port=8140/tcp --permanent',
         before => Exec['firewall-reload'],
   }

   exec {'firewall-reload':
         path => '/usr/bin',
         command => 'firewall-cmd --reload'
   }

   file {'/etc/puppet/manifests/site.pp':
        ensure => file,
        source => 'puppet:///modules/puppetmaster/site.pp',
   }

}
