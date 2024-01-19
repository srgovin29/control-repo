# profile::apache
# install apache with one vhost

class profile::apache (
  String[1] $webhost        = 'puppetagent02.devops.com',
  Stdlib::Port $port        = 80,
  Stdlib::Unixpath $docroot  = "/var/www/${webhost}",
  String[1] $ensure = 'file',
) { 
  class {'apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }

  apache::vhost { $webhost:
    port	        => $port,
    docroot	      => $docroot,
  }

  file { 'index.html':
    ensure	      => $ensure,
    path	        => "${docroot}/index.html",
    content	      => epp('profile/index.html.epp'),
    mode	        => '0644',
  }

  # Add mod_ssl
  apache::mod { 'ssl':
    ensure => present,
  }

  # Add mod_rewrite
  apache::mod { 'rewrite':
    ensure => present,
  }
}