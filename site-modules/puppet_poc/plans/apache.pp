# Plan puppet_poc::apache will help to create apache web site using Tasks 
plan puppet_poc::apache (
  TargetSpec   $webnodes,
  String $webuser = 'apacheadm',
  String $webgrp  = 'apachegrp',
  Integer $webuid =  14501,
  Integer $webgid = 14501,
  String $webpkg = 'httpd',
  String $websvc = 'httpd'
) {
  $web_results = apply($webnodes, '_catch_errors' => true, 'description' => "Setting up Webserver on node ${webnodes}") {
    group { $webgrp:
      ensure => present,
      gid    => $webgid,
    }
    -> user { $webuser:
      ensure             => present,
      gid                => $webgid,
      uid                => $webuid,
      password_max_age   => -1,
      password_warn_days => -1,
      password_min_age   => -1,
      shell              => '/bin/bash',
    }
    -> file { '/var':
      ensure => directory,
    }
    -> file { '/var/http/':
      ensure => directory,
    }
    -> file { '/var/http/www':
      ensure  => directory,
      owner   => $webuser,
      require => User[$webuser],
    }
    -> package { $webpkg:
      ensure => present,
    }
    -> service { $websvc:
      ensure => running,
      enable => true,
    }
  }
  $web_results.each | $result | {
    $node = $result.target.name
    if $result.ok {
      out::message("${node} retuned a value : ${result}.value")
    }
    else {
      out::message("${node} errored with a message: ${result.error}")
    }
  }
}
