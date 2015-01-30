node default {

  class { 'infra::foreman':
    answers => 'puppet:///modules/infra/foreman.answers.vagrant'
  }


}