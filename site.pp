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
    #require  => File['/etc/systemd/system/docker.service.d'],
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
  


}

node boot {
  include base
}
