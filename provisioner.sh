#!/bin/sh

#install the Puppet repo and the agent
yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y update
yum -y install puppet-agent

#run the main manifest
/opt/puppetlabs/bin/puppet apply /vagrant/site.pp