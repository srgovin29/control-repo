# This plan helps to install and enable tomcat application
plan puppet_poc::tomcat_e2e(
  TargetSpec   $appnodes,
  String       $appuser  = 'tomcat',
  String       $appgrp   = 'tomcat',
  Integer      $appuid   = 15001,
  Integer      $appgid   = 15001,
  String       $apphome  = '/opt/tomcat',
  Integer      $appport  = 8080,
  String       $appsvc   = 'tomcat',
) {
  $tomcat_app_results = apply($appnodes, '_catch_errors' => true , '_description' => "Setting up App Server on ${appnodes}") {
    package { 'java-1.8.0-openjdk-devel':
      ensure => present,
    }
    -> group { $appgrp:
      ensure => present,
      gid    => $appgid,
    }
    -> user { $appuser:
      ensure             => present,
      home               => $apphome,
      shell              => '/bin/false',
      gid                => $appgid,
      uid                => $appuid,
      password_max_age   => -1,
      password_warn_days => -1,
      password_min_age   => -1,
      managehome         => true,
    }
    -> file { '/opt/tomcat/apache-tomcat-8.5.98.tar.gz':
      ensure => file,
      source => 'puppet:///modules/puppet_poc/apache-tomcat-8.5.98.tar.gz',
    }
    -> file { '/etc/systemd/system/tomcat.service':
      ensure => file,
      source => 'puppet:///modules/puppet_poc/tomcat.service',
    }
  }
  # $tomcat_app_results.each |$result| {
  #  $target = $result.target.name
  # if $result.ok {
  #    notice("${target} returned a value: ${result.value}")
  #    notice("Printing full result output ${result}")
  #  } else {
  #    notice("${target} errored with a message: ${result.error.message}")
  #    notice("Print whole error message ${target} errored with a message: ${result.error}")
  # }
  # }
#### Running task from here to extract files and installing tomcat as
#### installation managed by non managed by ssytem tools 
  $tomcat_task_result = run_task('puppet_poc::tomcat_install',  $appnodes , 'appport' => $appport, 'appsvc' => $appsvc,
  'apphome' => $apphome,'_catch_errors' => true, '_description' => "Setting up App servers setup task on node ${appnodes}" )
  # $tomcat_task_result.each |$result| {
  #  $target = $result.target.name
  #  if $result.ok {
  #    notice("${target} returned a value: ${result.value}")
  #    notice("Printing stdout alsone ${result}")
  #  } else {
  #    notice("${target} errored with a message: ${result.error.message}")
  #    notice("Print whole error message ${target} errored with a message: ${result.error}")
  #  }
  # }
  $tomcat_results = { 'tomcat_apply_result' => $tomcat_app_results, 'tomcat_task_result' => $tomcat_task_result }
  return $tomcat_results
}
