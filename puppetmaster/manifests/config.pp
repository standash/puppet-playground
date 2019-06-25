class puppetmaster::config {

    $agent_hostname = $puppetmaster::agent_hostname

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
        content => template("${module_name}/site.pp.erb"),
   }

   file {'/etc/puppet/autosign.conf':
        ensure => file,
        content => template("${module_name}/autosign.conf.erb"),
   }
}
