#hiera_include('classes')

node 'agent.uni.lux' {
    include mysql
}
