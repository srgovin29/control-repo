# profile::apache
# install apache with one vhost

class profile::apache (
  Stdlib::Port $port = 80,
  String[1] $ensure = 'file',
) 
{
  $webhost = $facts['fqdn']
  $docroot = "/var/www/${webhost}"
/*  class {'apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  } */

  apache::vhost { "${webhost}":
    port	        => $port,
    docroot	      => $docroot,
  }

  file {'/var/www/':
     ensure     => directory,
  }->

  file {"/var/www/${webhost}":
     ensure     => directory,
  }->

  file { 'index.html':
    ensure	      => $ensure,
    path	        => "${docroot}/index.html",
    content	      => epp('profile/index.html.epp'),
    mode	        => '0644',
  }
}