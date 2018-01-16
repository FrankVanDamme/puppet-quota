# Class: quota
#
#
class quota inherits quota::params{
  $packages = $::quota::params::packages

  package { $packages:
    ensure => installed,
  }

}
