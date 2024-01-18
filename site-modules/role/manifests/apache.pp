class role::apache (
  String[1] $webhost        = "puppetagent02",
  Stdlib::Port $port        = 80,
  Stdlib::Unixpath $docroot  = "/var/www/${webhost}",
) {
  class { 'profile::apache':
    webhost  => $webhost,
    port     => $port,
    docroot  => $docroot,
  }
}