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
  String       $appsvc   = 'tomcat',
  #web configuration parameter
  String $webuser = 'apacheadm',
  String $webgrp  = 'apachegrp',
  Integer $webuid =  14501,
  Integer $webgid = 14501,
  String $webpkg = 'httpd',
  String $websvc = 'httpd',
  # DB configuration parameter
  String $dbsvc = 'mysqld',
  String $dbpkg = 'mysql-server',
) {
  $final_result = {}
  # $web_final_result = nil
  # $app_final_result = nil
  ### Setup DB server 
  $db_e2e_result = run_plan('puppet_poc::mysql_e2e',
    dbnodes => $dbnodes,
    dbsvc   => $dbsvc,
    dbpkg   => $dbpkg,
    '_catch_errors' => true,
    '_description'  => 'Database installtion and setup'
  )
  $db_e2e_result.to_data.each | $db_results | {
    $db_node = $db_results['target']
    $db_final_result = { $db_node => {
        'status' => $db_results['status'],
        'log' => $db_results['value']['report']['logs'],
        'output' => $db_results['value']['_output'],
      },
    }
    if $db_final_result[$db_node]['status'] != 'success' {
      fail_plan("The issue with DB server, Please check ${db_node}")
    } else {
      notice("Results from web server e2e : ${db_final_result}")
    }
    out::message($db_final_result)
  }

  #### Setup Application Server 
  $app_e2e_result = run_plan( 'puppet_poc::tomcat_e2e',
    appnodes => $appnodes,
    appuser  => $appuser,
    appgrp   => $appgrp,
    appuid   => $appuid,
    appgid   => $appgid,
    apphome  => $apphome,
    appport  => $appport,
    appsvc   => $appsvc,
    '_catch_errors' => true,
    '_description'  => 'App server pkg installtion and setup ',
  )
  # out::message("output result for app ${app_e2e_result}")
  $tt = ['tomcat_apply_result', 'tomcat_task_result']
  $tt.each | $app_task | {
    $app_e2e_result[$app_task].to_data.each | $app_results | {
      $app_node = $app_results['target']
      if $app_task != 'tomcat_task_result' {
        $app_final_result = { $app_node => {
            'status' => $app_results['status'],
            'log' => $app_results['value']['report']['logs'],
            'output' => $app_results['value']['_output'],
          },
        }
      }
      else {
        $app_final_result = { $app_node => {
            'status' => $app_results['status'],
          },
        }
        out::message($app_e2e_result[$app_task])
      }
      if $app_final_result[$app_node]['status'] != 'success' {
        fail_plan("The issue with App server, Please check ${app_node}")
      } else {
        notice("Results from web server e2e : ${app_final_result}")
      }
      out::message($app_final_result)
    }
  }
  #### Setup Web Application 
  $web_e2e_result = run_plan( 'puppet_poc::apache_e2e',
    webnodes => $webnodes,
    webuser  => $webuser,
    webgrp   => $webgrp,
    webuid   => $webuid,
    webgid   => $webgid,
    webpkg   => $webpkg,
    websvc   => $websvc,
    '_catch_errors' => true,
    '_description'  => 'Web Application installation and Setup'
  )
  $web_e2e_result.to_data.each | $web_results | {
    $web_node = $web_results['target']
    $web_final_result = { $web_node => {
        'status' => $web_results['status'],
        'log' => $web_results['value']['report']['logs'],
        'output' => $web_results['value']['_output'],
      },
    }
    if $web_final_result[$web_node]['status'] != 'success' {
      fail_plan("The issue with Webserver, Please check ${web_node}")
      # out::message("Results from web server e2e : ${final_result}")
    }
    # out::message("Results from web server web_output e2e : ${web_output}")
    # $final_result = { 'web_output' => $web_output }
    # notice("Results from web server e2e : ${web_final_result}")
    # $final_result2 = $final_result1.merge($web_final_result)
    out::message($web_final_result)
  }
  $web_app_db_svc_result = run_plan( 'puppet_poc::web_app_db_e2e',
    dbnodes => $dbnodes,
    dbsvc   => $dbsvc,
    dbpkg   => $dbpkg,
    appnodes => $appnodes,
    appuser  => $appuser,
    appgrp   => $appgrp,
    appuid   => $appuid,
    appgid   => $appgid,
    apphome  => $apphome,
    appport  => $appport,
    appsvc   => $appsvc,
    webnodes => $webnodes,
    webuser  => $webuser,
    webgrp   => $webgrp,
    webuid   => $webuid,
    webgid   => $webgid,
    webpkg   => $webpkg,
    websvc   => $websvc,
    '_catch_errors' => true,
    '_description'  => 'DB/App/Web Service status'
  )
  out::message($web_app_db_svc_result)
}
