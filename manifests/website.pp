#

define iis::website (
  String $website_name             = $title,
  String $pool_name                = $title,
  Enum['Present','Absent'] $ensure = 'Present',
  Enum['Stopped','Started'] $state = 'Started',
  String $website_path             = "C:\\inetpub\\${website_name}",
  Optional[String] $website_source = undef,
  Boolean $manage_website_path     = true,
  Integer $restart_mem_max         = 1000,
  Integer $restart_priv_mem_max    = 1000,
  Hash $binding_info               = { protocol => 'HTTP', port => 80 }
) {

  if !defined(Class['iis']) {
    fail("The IIS module must be in the catalog")
  }

  if $ensure == 'Present' {
    if $website_source == undef {
      $recurse = false
    } else {
      $recurse = true
    }

    dsc_file { $website_path:
      dsc_ensure          => 'Present',
      dsc_sourcepath      => $website_source,
      dsc_destinationpath => $website_path,
      dsc_recurse         => $recurse,
      dsc_type            => 'Directory',
      before              => Dsc_xwebapppool[$pool_name],
    }

    dsc_xwebapppool { $pool_name:
      dsc_ensure                    => 'Present',
      dsc_name                      => $pool_name,
      dsc_managedruntimeversion     => 'v4.0',
      dsc_logeventonrecycle         => 'Memory',
      dsc_restartmemorylimit        => $restart_mem_max,
      dsc_restartprivatememorylimit => $restart_priv_mem_max,
      dsc_identitytype              => 'ApplicationPoolIdentity',
      dsc_state                     => 'Started',
      before                        => Dsc_xwebsite[$website_name],
    }
  }

  dsc_xwebsite { $website_name:
    dsc_ensure        => $ensure,
    dsc_name          => $website_name,
    dsc_state         => $state,
    dsc_physicalpath  => $website_path,
    dsc_bindinginfo   => [ $binding_info ]
  }

}
