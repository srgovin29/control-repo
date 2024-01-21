## This plan is E2E setup for 3 tier Application 
$final_result = {}
$final_result['web'] = {}
$final_result['app'] = {}
$final_result['db'] = {}

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
  $web_e2e_result.each | $web_results | {
    final_result['web']['target'] = $web_results.target
    final_result['web']['target']['status'] =   $web_results.status
    final_result['web']['target']['log'] = $web_results.value.report.logs
    final_result['web']['target']['output'] = $web_results.value['_output']
  }
  out::message("Results from web server e2e : ${final_result}")
}
