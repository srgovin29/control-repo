## This plan is to install mysql server
plan puppet_poc::mysql_e2e(
  TargetSpec   $dbnodes,
  String $dbpkg = 'mysql-server',
  String $dbsvc = 'mysqld',
) {
  $mysql_results = apply($dbnodes, '_catch_errors' => true, '_description' => "Setting up Database server on ${dbnodes}" ) {
    package { $dbpkg:
      ensure => present,
    }
    service { $dbsvc:
      ensure => running,
      enable => true,
    }
  }
  return $mysql_results
}
