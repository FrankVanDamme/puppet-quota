# Quota

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What quota affects](#what-quota-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Contributors](#contributors)

## Overview

This module installs the **quota** type and provider to let you manage the quota settings
of the users and groups on your server infrastructure.

## Module Description

We use this module to set the block and inode quota for users and groups on our servers.
This module **does not** enable quota on the systems so this is still an action
that should be performed manually.

## Setup

### What quota affects

* This module handles the installation of the following packages
    * Debian
      * quota
      * quotatool
    * Red Hat
      * quota
* Apart from that this module sets the quota type and provider that
  can be used to st the block and inode limits per user/group

### Setup Requirements

Make sure that you have already manually enabled quota on the disk/volume
where you wish to manage the quota with this module.

## Usage

Include the class to ensure the required package(s) are installed, then use the `quota` resource type to specify your rule(s).

Example:
```ruby

class { '::quota': }

quota { 'username': 
  name             => 'username',
  ensure           => 'present',
  type             => 'user',
  filesystem       => '/srv/nfs',
  remote           => false,
  inode_soft_limit => '0',
  inode_hard_limit => '0',
  block_soft_limit => '94371840',
  block_hard_limit => '104857600',
}
```

## Reference

* **name**: This can be filled up with either a username, groupname, UID or GID
* **ensure**: Values can be _present_ or _absent_
* **type**: Can be _user_ or _group_
* **filesystem**: The location of the volume where quota will be set
* **remote**: _true_ or _false_ to determine if we are dealing with a remote filesystem
* **inode_soft_limit**: Should be an integer (0 = unlimited)
* **inode_hard_limit**: Should be an integer (0 = unlimited)
* **block_soft_limit**: Should be an integer in bytes (0 = unlimited)
* **block_hard_limit**: Should be an integer in bytes (0 = unlimited)

## Limitations

This module with its type and provider have only been tested on Debian systems.

## Contributors

* Dimitri Steyaert <github@dimitri.eu>
