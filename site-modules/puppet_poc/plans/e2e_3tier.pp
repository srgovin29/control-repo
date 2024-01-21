## This plan is E2E setup for 3 tier Application 
plan puppet_poc::e2e_3tier(
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
) {
  $final_result = {}
  #### Setup Web Application 
  $web_e2e_result = run_plan( 'puppet_poc::apache_e2e',
    webnodes => $webnodes,
    webuser => $webuser,
    webgrp  => $webgrp,
    webuid  => $webuid,
    webgid  => $webgid,
    webpkg  => $webpkg,
    websvc  => $websvc,
    '_catch_errors' => true,
  )
  $web_e2e_result.to_data.each | $web_results | {
    $web_output = { $web_results['target'] => {
        'status' => $web_results['status'],
        'log' => $web_results['value']['report']['logs'],
        'output' => $web_results['value']['_output'],
      },
    }
    $final_result = { 'web_output' => $web_output }
  }
  out::message("Results from web server e2e : ${final_result}")
}
