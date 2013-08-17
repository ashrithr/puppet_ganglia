class ganglia::webserver {

  case $operatingsystem {
    'Ubuntu': {
      $ganglia_webserver_pkg = 'ganglia-webfrontend'
      $ganglia_webserver_path = '/etc/apache2/sites-enabled/ganglia'
      $ganglia_apache_conf = 'ganglia.Debian.erb'
      $apacheservice = "apache2"
    }
    'CentOS': {
      $ganglia_webserver_pkg = 'ganglia-web'
      $ganglia_webserver_path = '/etc/httpd/conf.d/ganglia.conf'
      $ganglia_apache_conf = 'ganglia.RedHat.erb'
      $apacheservice = "httpd"
    }
  }

  include ganglia

  file { "/tmp/ganglia.tar":
    mode    => 0644,
    source  => "puppet:///modules/${module_name}/ganglia-web-3.5.10.tar",
    alias   => "ganglia-web-tar",
    before  => Exec["untar-ganglia-web"]
  }

  exec { "untar-ganglia-web":
    command     => "/bin/tar -xf /tmp/ganglia-web-3.5.10.tar -C /usr/share",
    creates     => "/usr/share/ganglia-web-3.5.10",
    refreshonly => true,
    before      => File["ganglia-web-dir"]
  }

  file { "/usr/share/ganglia-web":
    ensure  => "link",
    target  => "/usr/share/ganglia-web-3.5.10",
    mode    => 0644,
    alias   => 'ganglia-web-dir',
  }

  file { "/var/lib/ganglia":
    ensure  => "directory",
    owner   => "root",
    group   => "root",
    mode    => 0755,
    alias   => "ganglia-lib"
  }

  file { ["/var/lib/ganglia/dwoo", "/var/lib/ganglia/dwoo/cache", "/var/lib/ganglia/dwoo/compiled"]:
    ensure  => "directory",
    owner   => "apache",
    group   => "apache",
    mode    => 0755,
    require => File['ganglia-lib']
  }

  file { "/var/lib/ganglia/rrds":
    ensure  => "directory",
    owber   => "ganglia",
    group   => "ganglia",
    mode    => 0755,
    require => File["ganglia-lib"]
  }

  file { "/usr/share/ganglia-web/conf.php":
    ensure => file,
    content => template("ganglia/conf.php.erb"),
    require => File["ganglia-web-dir"]
  }

   file {$ganglia_webserver_path:
    ensure  => present,
    require => Package['ganglia_webserver'],
    content => template("ganglia/$ganglia_apache_conf"),
    notify  => Exec['refresh-apache']
  }

  exec { "refresh-apache":
    command => "/etc/init.d/${apacheservice} restart",
    refreshonly => true,
  }
}