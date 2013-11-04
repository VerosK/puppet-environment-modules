# puppet manifest

class environment_modules(
	$version = "3.2.10") {
	file { "/packages/":
		ensure => directory,
		owner => 'root'
	}
	file { "/packages/Modules":
		ensure => directory,
	}
	file { "/packages/Modulefiles":
		ensure => directory,
	}
	file { "/packages/Modules/source-${version}":
		ensure => directory,
	} ->
	exec { "Download modules ${version}":
		path => ['/bin','/usr/bin'],
		cwd => "/packages/Modules/source-${version}",
		command => "/usr/bin/wget http://sourceforge.net/projects/modules/files/Modules/modules-${version}/modules-${version}.tar.gz",
		creates => "/packages/Modules/source-${version}/modules-${version}.tar.gz",
	} ->
	exec { "Extract modules ${version}":
		path => ['/bin','/usr/bin'],
		cwd => "/packages/Modules/source-${version}",
		command => "/bin/tar xfz modules-${version}.tar.gz",
		creates => "/packages/Modules/source-${version}/modules-${version}",
	} ->
	exec { "Configure modules ${version}":
		path => ['/bin','/usr/bin'],
		cwd => "/packages/Modules/source-${version}/modules-${version}",
		command => "/packages/Modules/source-${version}/modules-${version}/configure --prefix=/packages --with-module-path=/packages/Modulefiles",
		creates => "/packages/Modules/source-${version}/modules-${version}/Makefile",
		require => Package['tcl-dev']
	} ->
	exec { "Compile modules ${version}":
		path => ['/bin','/usr/bin'],
		cwd => "/packages/Modules/source-${version}/modules-${version}",
		command => "make -j2",
		creates => "/packages/Modules/source-${version}/modules-${version}/modulecmd",
		require => [Package['tcl-dev'], Packages['gcc']
	} ->
	exec { "Install modules ${version}":
		path => ['/bin','/usr/bin'],
		cwd => "/packages/Modules/source-${version}/modules-${version}",
		command => "make install",
		creates => "/packages/Modules/${version}/bin/modulecmd"
	} 
        file { "/etc/profile.d/modules.sh":
		ensure => link,
		target => "/packages/Modules/${version}/init/bash",
		require => Exec["Install modules ${version}"],
	}
	
	if !defined(Package['tcl-dev']) {	
		package {"tcl-dev": }
	}
	if !defined(Package['gcc']) {	
		package {"gcc": }
	}
}
