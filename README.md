# dcos-vagrant-puppet

## Overview

A simple, monotithic DC/OS puppet installer that demos the DC/OS advanced installation process.

* Creates a local Vagrant cluster of 3 nodes {bootstrap,master,private agent}
* Runs masterless Puppet
  * Applies all pre-requisites, repos, system changes
  * Configures the bootstrap node with the DC/OS open source installer
  * Installs each node as per their role

## Pre-requisites

* Install the latest version of:
  * Vagrant + vagrant-hostsupdater & vagrant-vbguest plugins
  * VirtualBox
  * Puppet to allow the Vagrant provisioner to bootstrap the node configuration
  * Facter for Puppet to use
* Clone this repository locally into a folder where you'll execute it from, I tend to use ~/code/$project
  `git clone git@gitub.com:aggress/dcos-vagrant-puppet ~/code/`
* Symlink the Vagrantfile you want to use `ln -s Vagrantfile-cluster Vagrantfile`
* Download the ~800MB DC/OS installation file to the project directory as you only want to get it once
  `curl -fsSLO https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh`

## Usage

* `cd ~/code/docs-vagrant-puppet`
* run `vagrant up` to launch the Vagrant cluster
* When complete, go to the master UI http://192.168.33.11
* To destroy, run `vagrant destroy -f`

## Notes

* It's monolithic to make it real easy to understand the steps
* It's not intended to be production grade or designed to be all you need for your deployment

## Limitations

* Has only been designed to run on CentOS 7
* No Heira integration
* Designed to run masterless