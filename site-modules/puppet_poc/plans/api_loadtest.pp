plan puppet_poc::api_loadtest (
  TargetSpec   $midnode = 'puppetmaster.devops.com'
) {
  $tasks_api = ['puppet_poc::a1_weather','puppet_poc::a2_food_reci','puppet_poc::a3_dicebear','puppet_poc::a4_pic_sum',
    'puppet_poc::a5_crossref','puppet_poc::a6_tradesite','puppet_poc::a7_tvmaze','puppet_poc::a8_qr_code',
    'puppet_poc::a9_microlink','puppet_poc::a10_boredapi','puppet_poc::a12_jokeapi','puppet_poc::a13_asterank',
  'puppet_poc::a14_reqres','puppet_poc::a15_dummy_create','puppet_poc::a16_dummy_update','puppet_poc::a17_dummy_del']
  output = {}
  $tasks_api.each do | $api_task | {
    $task_output = run_task($api_task, $midnode, '_catch_errors' => true ,'_description' => "Task - ${api_task} is running")
    output[$api_task] => $task_output
  }
  out::message($output)
}
