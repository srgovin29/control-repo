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
  String       $appsvc   = tomcat,
  #web configuration parameter
  String $webuser = 'apacheadm',
  String $webgrp  = 'apachegrp',
  Integer $webuid =  14501,
  Integer $webgid = 14501,
  String $webpkg = 'httpd',
  String $websvc = 'httpd'
) {
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
    fail_plan("Webservice named ${websvc} is not running , so plan fail here itself. 
       Can you please login ${webnodes} and verify the status" )
    }   else {
    out::message("Web Service is up and running and the status is : ${web_status_res}") }
  }
  #### Starting App service 
  $app_status = run_command( "systemctl show -p SubState -p ActiveState ${appsvc}", $appnodes )
  $app_status.to_data.each | $app_result | {
    notice("result is :${app_result}")
    $app_status_res = $app_result['value']['stdout']
    notice("value for stdout: ${app_status_res}")
    if $app_status_res != "ActiveState=active\nSubState=running\n" {
    fail_plan("App Service named ${appsvc} is not running , so plan fail here itself. 
       Can you please login ${appnodes} and verify the status" )
    }   else {
      out::message("App Service is up and running and the status is : ${app_status_res}")
    }
  }
}
