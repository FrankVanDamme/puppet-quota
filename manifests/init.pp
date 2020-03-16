# Class: quota
#
# @param packages
#   Specifies which packages to install for managing quota. Differs per operating system family
#
# @param ensure
#   Wether to install the quota package, and what version to install. 
#
class quota(
  Array $packages,
  String $ensure,

){

  package { $packages:
    ensure => $ensure,
  }

}
