#!/bin/bash -e

echo -e "Building CentOS 6.6 box..."
if [ ! -f builds/packer-centos-6.6-x86_64.ovf ]; then
	packer build centos-6.6.json
fi

echo -e "Installing Puppet modules..."
librarian-puppet install > /dev/null

echo -e "Building Puppetmaster box..."
if [ ! -f builds/packer-puppetmaster.box ]; then
	packer build puppetmaster.json
	vagrant init --force builds/packer-puppetmaster.box
	vagrant up
	vagrant ssh -c 'sudo /vagrant/generate_certs.sh'
	vagrant destroy
	vagrant box remove --force builds/packer-puppetmaster
	rm -f Vagrantfile
fi

echo -e "Building Foreman box..."
if [ ! -f builds/packer-foreman.box ]; then
	packer build foreman.json
fi

echo -e "Building PuppetDB box..."
if [ ! -f builds/packer-puppetdb.box ]; then
	packer build puppetdb.json
fi

echo -e "Cleaning up certificates..."
rm -f foreman.localdomain.* puppetdb.localdomain.* ca.pem
