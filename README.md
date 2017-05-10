# dcos-vagrant-puppet

## Overview

A simple, monolithic puppet manifest that installs DC/OS onto a Vagrant cluster

* Creates a local Vagrant cluster of 3 nodes {bootstrap,master,private agent}
* Runs masterless Puppet
  * Applies all pre-requisites, repos, system changes
  * Configures the bootstrap node with the DC/OS open source installer
  * Installs each node as per their role

## Pre-requisites

1. Install the latest versions of:
  * Vagrant + vagrant-hostsupdater & vagrant-vbguest plugins
  * VirtualBox
2. Clone this repository locally into a folder where you'll execute it from

   `git clone git@gitub.com:aggress/dcos-vagrant-puppet ~/code/`

3. Download the ~800MB DC/OS installation file to the project directory as you only want to get it once

   `curl -O https://downloads.dcos.io/dcos/stable/dcos_generate_config.sh`

## Usage

* `cd dcos-vagrant-puppet`
* Run `vagrant up` to launch and provision, takes ~12 minutes.
* When complete, go to the master UI http://192.168.33.11
* To destroy, run `vagrant destroy -f`

## Notes

* Designed to run masterless
* It's monolithic to make it really easy to understand the steps
* I used the shell provisioner to bootstrap Puppet on the guest VMs, as it was the simplest
* Built for the open source DC/OS release, can be easily updated for the Enterprise version

## Limitations

* Has been designed to run on CentOS 7
* It's not intended to be production grade or designed to be all you need for your deployment