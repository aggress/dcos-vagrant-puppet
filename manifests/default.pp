# Base class for all nodes
class base {
 
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/opt/puppetlabs/bin' ] }

  exec { 'puppet masterless exec':
    command  =>  '/opt/puppetlabs/bin/puppet apply site.pp',
    cwd      => '/vagrant',
  }
}

node 'bootstrap' {
  include base
} ->

node 'master' {
  include base
} ->

node 'private-agent' {
  include base
}