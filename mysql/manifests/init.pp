class mysql (
    $repo_url = 'https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm',
    $root_password ='iamroot',
    $new_username = 'dummy',
    $new_username_pwd = 'ditto',
) {
    contain mysql::install
    contain mysql::service
    contain mysql::config

    Class['mysql::install'] -> Class['mysql::service'] -> Class['mysql::config']
}
