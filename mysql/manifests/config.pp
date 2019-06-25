class mysql::config {

    exec {'create-dummy-db':
        path => '/usr/bin',
        command => "mysql -e \"create database dummydb; 
                    create table dummydb.test (id INT); 
                    insert into dummydb.test (id) values (666);     
                    grant select on dummydb.test to '${mysql::new_username}'@'localhost' 
                    identified by '${mysql::new_username_pwd}';\"",
    }

    exec {'set-root-passwd':
        path => '/usr/bin',
        command => "mysql -e \"set password for 'root'@'localhost' = password('${mysql::root_password}'); flush privileges;\"",
        require => Exec['create-dummy-db'],
    }
}

