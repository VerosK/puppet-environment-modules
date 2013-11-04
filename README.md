puppet-environment-modules
==========================

This is Puppet module for installing and configuring environment modules:[1]

Download as submodule
---------------------

- `cd` into `/etc/puppet` (versioned)
- `git submodule add https://github.com/VerosK/puppet-environment-modules modules/environment_modules`

or simply clone

- `cd` into `/etc/puppet/modules`
- `git clone https://github.com/VerosK/puppet-environment-modules environment_modules`

Usage
-----

`class { "environment-modules": }` into your manifest


Tested on Ubuntu LTS, YMMV.
	

[1]:http://modules.sourceforge.net/


