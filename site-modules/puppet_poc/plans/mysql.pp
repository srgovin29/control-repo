## This plan is to install mysql server
plan puppet_poc::mysql(
  TargetSpec   $webnodes,
  Integer      $dbnodes,
) {
  $mysql_results = apply($dbnodes, '_catch_errors' => true ) {
    package { 'mysql-server':
      ensure => present,
    }
    service { 'mysqld1.service':
      ensure => running,
      enable => true,
    }
  }
  $mysql_results.each |$result| {
    $target = $result.target.name
    if $result.ok {
      out::message("${target} Full result value: ${result}")
      notice('=============================================')
      out::message("${target} returned a value: ${result.value}")
    } else {
      out::message("${target} Full result value: ${result}")
      notice('=============================================')
      out::message("${target} errored with a message: ${result.error.message}")
    }
  }
}
