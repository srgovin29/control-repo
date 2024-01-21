## This plan is to install mysql server
plan puppet_poc::web_app_db_e2e(
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
  String       $appsvc   = tomcat,
  #web configuration parameter
  String $webuser = 'apacheadm',
  String $webgrp  = 'apachegrp',
  Integer $webuid =  14501,
  Integer $webgid = 14501,
  String $webpkg = 'httpd',
  String $websvc = 'httpd',
  # DB configuration parameter
  String $dbsvc = 'mysqld',
  String $dbpkg = 'mysql-server'
) {
  ### Starting DB service 
  $db_status = run_command( "systemctl show -p SubState -p ActiveState ${dbsvc}", $dbnodes )
  $db_status.to_data.each | $db_result | {
    notice("result is :${db_result}")
    $db_status_res = $db_result['value']['stdout']
    notice("value for stdout: ${db_status_res}")
    if $db_status_res != "ActiveState=active\nSubState=running\n" {
    fail_plan("DB Service named ${dbsvc} is not running , so plan fail here itself. 
       Can you please login ${dbnodes} and verify the status" )
    }   else {
      out::message("DB Service is up and running and the status is : ${db_status_res}")
    }
  }
  #### Starting App service 
  $app_status = run_command( "systemctl show -p SubState -p ActiveState ${appsvc}", $appnodes )
  $app_status.to_data.each | $app_result | {
    notice("result is :${app_result}")
    $app_status_res = $app_result['value']['stdout']
    notice("value for stdout: ${app_status_res}")
    if $app_status_res != "ActiveState=active\nSubState=running\n" {
    fail_plan("DB service is up, But App Service named ${appsvc} is not running , so plan fail here itself. 
       Can you please login ${appnodes} and verify the status" )
    }   else {
      out::message("DB and App Services are up and running. App service status is : ${app_status_res}")
    }
  }
  ### Starting web service 
  $web_status = run_command( "systemctl show -p SubState -p ActiveState ${websvc}", $webnodes )
  notice("value is: ${web_status}")
  $web_status.to_data.each | $result | {
    notice("result is :${result}")
    $web_status_res = $result['value']['stdout']
    notice("value for stdout: ${web_status_res}")
    # $web_status.to_data.each | $result_hash | {
    # $web_status_res = $result_hash['result']['stdout']
    if $web_status_res != "ActiveState=active\nSubState=running\n" {
    fail_plan("DB and App services are running but Webservice named ${websvc} is not running , so plan fail here itself. 
       Can you please login ${webnodes} and verify the status" )
    }   else {
    out::message("DB,App and Web Service are up and running. Web service status is : ${web_status_res}") }
  }
  return [$db_status, $app_status, $web_status]
}
