## This plan is to install mysql server
plan puppet_poc::mysql(
  TargetSpec   $dbnodes,
  String $dbpkg = 'mysql-server',
  String $dbsvc = 'mysqld',
) {
  $mysql_results = apply($dbnodes, '_catch_errors' => true,'_description' => "Setting up Database server on ${dbnodes}" ) {
    package { 'mysql-server':
      ensure => present,
    }
    service { 'mysqld.service':
      ensure => running,
      enable => true,
    }
  }
  $mysql_results.each |$result| {
    $target = $result.target.name
    if $result.ok {
      out::message("${target} Full result value for success: ${result}")
      notice('=============================================')
      out::message("${target} returned a value for success: ${result.value}")
    } else {
      out::message("${target} Full result value for failure: ${result.value['report']['logs']}")
      notice('=============================================')
      out::message("${target} errored with a message for failure: ${result.error.message}")
    }
  }
}
