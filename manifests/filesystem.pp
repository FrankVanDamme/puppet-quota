define quota::filesystem ( ) {
    $filesystem = $name

    # turn off quota for the file system, initialize quota, then turn them
    # back on again, only if the quota.user of quota.group files don't exist
    # yet

    exec { "quotaoff":
        command     => "/sbin/quotaoff -vug $filesystem",
        refreshonly => true,
    }
    exec { "quotaon":
        command      => "/sbin/quotaon -vug $filesystem",
	refreshonly  => true,
    }
  
    exec { "quotacheck_u":
        command => "/sbin/quotacheck -cum $filesystem",
        creates => "/var/www/local/quota.user",
        before  => Exec['quotaon'],
        require => Exec['quotaoff'],
    }
    exec { "quotacheck_g":
        command => "/sbin/quotacheck -cgm  $filesystem",
        creates => "/var/www/local/quota.group",
        before  => Exec['quotaon'],
        require => Exec['quotaoff'],
    }
}
