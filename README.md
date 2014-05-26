exoscale-symfony2
==================

A PHP environment to deploy on [exoscale](http://www.exoscale.ch/open-cloud/compute/) or any cloud-init compatible cloud with plain vanilla Ubuntu instances.

## Principles:

This cookbook will leverage userdata extensibility of CloudStack and the features of cloud-init to 
bootstrap a Symfony2 structure.

* Userdata will be filled with a script
* Script will be called on first boot by cloud-init
* A puppet repository will be pulled on the instance
* The script will launch Puppet and apply the manifest and eventually after PHP, NGINX and MYSQL installation

Keep it mind that it is possible to go much further in automation deployment.

## Usage guide:

### Start an instance

Launch a new Ubuntu 14.04 LTS instance with the service offering you wish. Insert it in a security group or with firewall rules which enable port 80/http.

### User Data with Cloud-init

In the User Data tab, input the script below:

    #!/bin/sh
    set -e -x

    wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    dpkg -i puppetlabs-release-precise.deb
    apt-get --yes --quiet update
    apt-get --yes --quiet install puppet git

    #
    # Fetch puppet configuration from public git repository.
    #

    mv /etc/puppet /etc/puppet.orig
    git clone https://github.com/ch-apptitude/exoscale-symfony2.git /etc/puppet

    #
    # Run puppet.
    #

    puppet apply /etc/puppet/manifests/init.pp
    #Debug mode
    # puppet apply /etc/puppet/manifests/init.pp --debug > /var/log/puppet/init-error.log

### Start using your fresh  Symfony2

Now symfony-standard-edition 2.4.4 is installed and working. 
For deploy your project on the server you can use capifony (http://capifony.org/)


### Advanced usage

For anything other than testing, we recommend forking this repository and modify the config/common.csv file with your details.
Of course also alter the git clone argument passed to your instance via user-data to match your personal repository.

## Modify:

To modify your configuration, clone this very repository and adjust files and manifests accordingly. 
Do not forget to replace the URL in the userdata script.

## Trooblshooting: 

Wait few minutes after server ready on your exoscale console.

## Credits:

this is inspired by the work of [chadthompson]: http://chadthompson.me on https://github.com/chad-thompson/vagrantpress
this is inspired by the work of [exoscale]: http://exoscale.ch on https://github.com/exoscale/exoscale-wordpress