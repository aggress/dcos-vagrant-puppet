# dcos-vagrant-puppet

## Overview

A simple, monotithic DC/OS puppet installer that demos the DC/OS advanced installation process.

* Creates a local Vagrant cluster of 3 nodes {bootstrap,master,private agent}
* Runs masterless Puppet
  * Applies all pre-requisites, repos, system changes
  * Configures the bootstrap node with the DC/OS open source installer
  * Installs each node as per their role

## Pre-requisites

1. Install the latest version of:
  * Vagrant + vagrant-hostsupdater & vagrant-vbguest plugins
  * VirtualBox
  * Puppet to allow the Vagrant provisioner to bootstrap the node configuration
  * Facter for Puppet to use
2. Clone this repository locally into a folder where you'll execute it from, I tend to use ~/code/$project
  *`git clone git@gitub.com:aggress/dcos-vagrant-puppet ~/code/`
3. Symlink the Vagrantfile you want to use `ln -s Vagrantfile-cluster Vagrantfile`
4. Download the ~800MB DC/OS installation file to the project directory as you only want to get it once
  * `curl -fsSLO https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh`

## Vagrant box

Using Puppet for the Vagrant provisioner requires the guest VM having Puppet on there, chicken/egg etc.
That's easily achieved by firing up a vanilla centos/7 box, installing the Puppet repo & puppet-agent.
Do a full system update, then package the box and add to Vagrant to use.  I prefer to remove the existing centos/7 box and replace it with the newly packaged one as then I just default to it each time.

1. Build yourself a fresh new box `mkdir ~/vagrant/centos7_puppet && cd ~/vagrant/centos7_puppet`
2. Initialise it and fire it up `vagrant init centos/7` && vagrant up`
3. SSH into the box and su - `vagrant ssh` `sudo su -`
4. `rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm`
5. `yum -y update`
6. `yum -y install puppet-agent`
7. Exit from the box back to your host
8. `vagrant package --output centos7_updated.box`
9. `vagrant box remove centos/7`
10. `vagrant box add -f centos/7 centos7_updated.box`
11. `vagrant box list` to see the replacement centos/7 box

The other advantage of this, is that you've saved a box with the latest yum updates and vbguest additions
which will reduce the startup time going forwards.

## Usage

* `cd ~/code/dcos-vagrant-puppet`
* run `vagrant up` to launch the Vagrant cluster
* When complete, go to the master UI http://192.168.33.11
* To destroy, run `vagrant destroy -f`

## Notes

* Designed to run masterless
* It's monolithic to make it real easy to understand the steps

## Limitations

* Only been designed to run on CentOS 7
* It's not intended to be production grade or designed to be all you need for your deployment
