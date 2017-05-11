# Base class for all nodes
class base {

  $required_packages = [ 'unzip', 'tar', 'xz', 'curl', 'ipset', 'ntp', 'nc' ]

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

  package { $required_packages:
    ensure   => 'installed',
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

  group { 'nogroup':
    ensure   => 'present',
  }

  # dc/os does not like being out of time
  exec { 'ntpdate':
    command  => 'ntpdate 0.pool.ntp.org',
  }

  exec { 'enable systemd-timesyncd':
    command  => 'timedatectl set-ntp true',
  } ->

  # ensures the hardware clock is aligned with the system
  exec { 'set local-rtc to 0 for utc':
    command  => 'timedatectl set-local-rtc 0',
  }

  service { 'docker':
    ensure   => 'running',
    enable   => true,
    require  => Package['docker-engine-1.13.1'],
  }
}

# Bootstrap node class for hosting installer
class bootstrap_install {

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

  # you'll have already downloaded this file to where you launch vagrant from
  file { '/root/dcos_generate_config.ee.sh':
    ensure   => 'link',
    target   => '/vagrant/dcos_generate_config.ee.sh',
  }

  # amend for your network choices
  file { '/root/genconf/config.yaml':
    ensure   => file,
    content  => file('/vagrant/config.yaml'),
  }

  exec { 'dcos_generate_config':
    command  => 'bash dcos_generate_config.ee.sh',
    cwd      => '/root',
  }

  exec { 'launch bootstrap nginx container':
    command  => 'docker run -d -p 80:80 -v /root/genconf/serve:/usr/share/nginx/html:ro nginx',
  }
}

# Master node class
class master_install {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/opt/puppetlabs/bin' ] }

  exec { 'curl the installer file from the boostrap node':
    command  => 'curl -fsSLO http://192.168.33.10:80/dcos_install.sh',
    cwd      => '/root',
  }

  exec { 'run the installer for master node':
    command  => 'bash /root/dcos_install.sh master',
    cwd      => '/root',
  }
}

# Public agent node class
class private_agent_install {

  Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/', '/opt/puppetlabs/bin' ] }

  exec { 'curl the installer file from the boostrap node':
    command  => 'curl -fsSLO http://192.168.33.10:80/dcos_install.sh',
    cwd      => '/root',
  }

  exec { 'run the installer for public agent node':
    command  => 'bash /root/dcos_install.sh slave',
    cwd      => '/root',
  }

}

node 'bootstrap' {
  include base
  include bootstrap_install
}

node 'master' {
  include base
  include master_install
}

node 'private-agent' {
  include base
  include private_agent_install
}
