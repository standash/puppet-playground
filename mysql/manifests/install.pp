class mysql::install {


   package {'hiera-eyaml':
       provider => gem,
       ensure => installed,
   }

   package {'mysql-repo':
       provider => 'rpm',
       ensure => installed,
       source => $mysql::repo_url,
       require => Package['hiera-eyaml'],
   }

   package {'yum-utils':
       ensure => installed,
       require => Package['mysql-repo'],
   }

   exec {'enable-required-repo':
       path => '/usr/bin',
       command => "yum-config-manager --disable mysql*-community && yum-config-manager --enable mysql56-community",
       require => Package['yum-utils']
   }

   package {'mysql-community-server':
       ensure => installed,
       require => Exec['enable-required-repo'],
   }        


}
