## This plan is to install mysql server
plan puppet_poc::web_app_db(
  TargetSpec   $dbnodes = 'puppetagent03.devops.com',
  TargetSpec   $webnodes = 'puppetagent01.devops.com',
  TargetSpec   $appnodes = 'puppetagent02.devops.com',
  #app configuration parameter
  String       $appuser  = 'tomcat',
  String       $appgrp   = 'tomcat',
  Integer      $appuid   = 15001,
  Integer      $appgid   = 15001,
  String       $apphome  = '/opt/tomcat',
  Integer      $appport  = 8080,
  #web configuration parameter
  String $webuser = 'apacheadm',
  String $webgrp  = 'apachegrp',
  Integer $webuid =  14501,
  Integer $webgid = 14501,
  String $webpkg = 'httpd',
  String $websvc = 'httpd'
) {
  $web_status = run_command( "systemctl show -p SubState -p ActiveState ${websvc}", $webnodes )
  $web_status.each | $result_hash | {
    $web_status_res = $result_hash['result']['stdout']
    if $web_status_res != "ActiveState=active\nSubState=running\n" {
    fail_plan("Webservice named ${websvc} is not running , so plan fail here itself. 
       Can you please login ${webnodes} and verify the status" )
    }   else {
      $web_status.each | $result_hash | { out::message("result is : ${result_hash}") }
    }
  }
}
