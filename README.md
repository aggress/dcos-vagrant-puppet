# dcos-vagrant-puppet

## Overview

A simple DC/OS puppet installer that demos the DC/OS advanced installation process. This
is not meant to be production grade or designed to be all you need for your deployment.

* Creates a local Vagrant cluster of 3 nodes {bootstrap,master,private agent}
* Applies all pre-requisites, repos, system changes
* Configures the bootstrap node with the DC/OS open source installer
* Installs each node

## Usage

* Install the latest version of:
  * Vagrant + vagrant-hostsupdater, vagrant-vbguest plugins
  * VirtualBox
* Check out this repository locally into a folder where you'll execute it from like ~/vagrant
* Download the config generator in that folder 'curl -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh'
* Amend Vagrantfile as required for your network
* run `vagrant up`
* SSH to the bootstrap, master and agent in order and run `cd /vagrant && puppet apply site.pp`
* When complete, goto http://master_ip:443 and log into the UI

## Limitations

* Only been designed to run on CentOS 7
* No Heira integration
* Designed to run masterless