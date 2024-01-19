# profile::apache
# install apache with one vhost

class profile::apache (
  String[1] $webhost        = 'puppetagent02.devops.com',
  Stdlib::Port $port        = 80,
  Stdlib::Unixpath $docroot  = "/var/",
  String[1] $ensure = 'file',
) {


  file { 'index.html':
    ensure	      => $ensure,
    path	        => "${docroot}/index.html",
    content	      => epp('profile/index.html.epp'),
    mode	        => '0644',
  }
} 