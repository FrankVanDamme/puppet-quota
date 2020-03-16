# Class: quota
#
#
class quota(
  Array $packages,
  Enum['present', 'absent', 'installed', 'latest'] $ensure,

){

  package { $packages:
    ensure => $ensure,
  }

}
