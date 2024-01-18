node 'puppetagent02.devops.com' {
  include stdlib
  class { java: stage => 'runtime' }
  include role::apache
}