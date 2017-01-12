Vagrant LEMP Stack
=================

Description
-----------

Setup a LEMP dev environment using Vagrant and PuPHPet.

INSTALL/SETUP A BASIC LEMP STACK (LINUX, NGINX, MYSQL, PHP) ON Ubuntu Trusty 16.04 LTS x64

Requirements
------------

* [VirtualBox](https://www.virtualbox.org) (The official recommended Virtualbox version is 5.0.26!)
* [Vagrant](http://vagrantup.com) (version 1.8.6 or newer)
* abandon your old WAMP/MAMP environnement 
* some patience :)

Installation
------------

Clone the repository:


	$ git clone https://github.com/oussaka/lemp-stack.git
	$ cd lemp-stack

Then, you should be able to use:


	$ vagrant up


Once everything is done you can log into the virtual machine:


	$ vagrant ssh

put your projects in www and go to http://local.dev


What's Inside
-----------

#### Installed software:


* Ubuntu Trusty 16.04 LTS x64
* nginx 1.10.2 (ppa: https://launchpad.net/~ondrej/+archive/ubuntu/nginx)
* MariaDB Server 10.2
* php 5.6.9 (ppa: https://launchpad.net/~ondrej/+archive/ubuntu/php5-5.6)
* git
* node 6
* npm 3.10
* redis server 3.0.6
* MailHog (port 8025)


Information
-----------

* Virtual Machine IP: 192.168.56.101
* go to http://local.dev
* PHP 5.6 installed
* MySQL user/password: user/pass
* node, npm (some useful packages: grunt, grunt-cli, yoeman, bower, express, gulp, ungit)


How do I update my hosts file?
------------------------------

You will need to open and edit your hosts file with a text editor like notepad, sublime_text, nano, etc. The location of the hosts file varies by operation system.

Windows users could look here: c:\windows\system32\drivers\etc\hosts

Linux and Mac OSX users could look here: /etc/hosts.

Example Entry: 
	
	192.168.56.101 local.dev www.local.dev


Virtual Machine Management
--------------------------

When done just log out with `^D` and suspend the virtual machine

	$ vagrant suspend


then, resume to hack again

	$ vagrant resume


run

	$ vagrant halt


to shutdown the virtual machine, and

	$ vagrant up


to boot it again.

You can find out the state of a virtual machine anytime by invoking

	$ vagrant status


You can run your own custom code after the VM finishes provisioning by adding files to the **puphpet/files/exec-always**, **puphpet/files/exec-once**, **puphpet/files/startup-always**, and **puphpet/files/startup-once** folders.

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

	$ vagrant destroy # DANGER: all is gone



Troubleshooting
---------------

### 
