class base {
 
  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/opt/puppetlabs/bin' ] }

  yumrepo { 'docker':
    enabled  => 1,
    descr    => 'Docker repo',
    baseurl  => 'https://yum.dockerproject.org/repo/main/centos/7/',
    gpgcheck => 1,
    gpgkey   => 'https://yum.dockerproject.org/gpg',
  }

  exec { 'yum update':
    command  => 'yum -q -y update',
    require  => Yumrepo['docker'],
  }

  package { 'docker-engine-1.13.1':
    ensure   => 'installed',
    require  => Exec['yum update'],
  }

  file { '/etc/modules-load.d/overlay.conf':
    content  => 'overlay',
  }

  file { '/etc/systemd/system/docker.service.d':
    ensure   => 'directory',
  }

  file { '/etc/systemd/system/docker.service.d/override.conf':
    content  => "[Service]\nExecStart=\nExecStart=/usr/bin/dockerd --storage-driver=overlay"
  }

  exec { 'selinux permissive':
    command  => 'setenforce 0',
  }

  service { 'ntpd':
    ensure   => 'running',
    enable   => 'true',
  }

  service { 'docker':
    ensure   => 'running',
    enable   => 'true',
    require  => Package['docker-engine-1.13.1'],
  }
}

class bootstrap {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/opt/puppetlabs/bin' ] }

  $str = @(EOT)
    #!/usr/bin/env bash
    set -o nounset -o errexit
    export PATH=/usr/sbin:/usr/bin:$PATH
    echo $(ip addr show eth1 | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
    | EOT

  file { '/root/genconf':
    ensure   => 'directory',
  }

  file { '/root/genconf/ip-detect':
    ensure   => file,
    content  => $str,
  }

  file { '/root/dcos_generate_config.sh':
    ensure   => 'link',
    target   => '/vagrant/dcos_generate_config.sh',
  }

  file { '/root/genconf/config.yaml':
    ensure   => file,
    content  => file('/vagrant/config.yaml'),
  }

  exec { 'dcos_generate_config':
    command  => 'bash dcos_generate_config.sh',
    cwd      => '/root'
  }

}

node boot {
  include base
  include bootstrap
}
