#

define iis::application (
  String $app_name                  = $title,
  Enum['Present','Absent'] $ensure  = 'Present',
  String $app_path                  = "C:\\inetpub\\${title}",
  String $app_pool                  = $title,
  Optional[String] $app_source      = undef,
  Integer $restart_mem_max          = 1000,
  Integer $restart_priv_mem_max     = 1000,
) {

  if $ensure == 'Present' {
    if $app_source == undef {
      $recurse = false
    } else {
      $recurse = true
    }

    dsc_file { $app_path:
      dsc_ensure          => 'Present',
      dsc_sourcepath      => $app_source,
      dsc_destinationpath => $app_path,
      dsc_recurse         => $recurse,
      dsc_type            => 'Directory',
      before              => Dsc_xwebapppool[$app_pool],
    }

    dsc_xwebapppool { $app_pool:
      dsc_ensure                    => 'Present',
      dsc_name                      => $app_pool,
      dsc_managedruntimeversion     => 'v4.0',
      dsc_logeventonrecycle         => 'Memory',
      dsc_restartmemorylimit        => $restart_mem_max,
      dsc_restartprivatememorylimit => $restart_priv_mem_max,
      dsc_identitytype              => 'ApplicationPoolIdentity',
      dsc_state                     => 'Started',
      before                        => Dsc_xwebapplication[$app_name],
    }
  }

  dsc_xwebapplication { $app_name:
    dsc_ensure        => $ensure,
    dsc_name          => $app_name,
    dsc_physicalpath  => $app_path,
    dsc_webapppool    => $app_pool,
  }
}
