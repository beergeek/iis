# The defined type manages websites, website directory, app pools, and web applications.
#
# @param app_ensure Determine if web application is created or removed, if `app_name` is used. Default to `Present`.
# @param app_path Path for web application. Defaults to `C:\\inetpub\\${website_name}`.
# @param binding_hash Array of hashes for binding information for website. Default is `[{ protocol => 'HTTP', port => 80, hostname =>
# $title }]`.
# @param directory_owner SID or name of website directory owner. Defaults to `S-1-5-17`.
# @param ensure Determine if website is created or removed. Default is `Present`.
# @param pool_name The of application pool. Defaults to `$title`.
# @param restart_mem_max The limit for restart memory for Application Pool. Default is `1000`.
# @param restart_priv_mem_max The limit for the restart private memory for the Application Pool. Default is `1000`.
# @param state Determine if website is started or stopped. Default is `Started`.
# @param website_name The name of the website. Defaults to `$title`.
# @param website_source Source for website to be used in `file` resource.  Will recurse if provided. Default is `undef`.
# @param app_name Name of web application. Default is `undef`.
# @param website_path Path for website. Defaults to `C:\\inetpub\\${website_name}`.
define iis::website (
  Array[Hash] $binding_hash                                = [{ protocol => 'HTTP', port => 80, hostname => $title }],
  Enum['Present','present','Absent','absent'] $app_ensure  = 'Present',
  Enum['Present','present','Absent','absent'] $ensure      = 'Present',
  Enum['Stopped','stopped','Started','started'] $state     = 'Started',
  Integer $restart_mem_max                                 = 1000,
  Integer $restart_priv_mem_max                            = 1000,
  String $directory_owner                                  = 'S-1-5-17',
  String $pool_name                                        = $title,
  String $website_name                                     = $title,
  String $website_path                                     = "C:\\inetpub\\${website_name}",
  Optional[String] $app_name                               = undef,
  Optional[String] $app_path                               = "C:\\inetpub\\${app_name}",
  Optional[String] $website_source                         = undef,
  Optional[Hash] $website_directory_acl                    = undef,
) {

  if !defined(Class['iis']) {
    fail('The IIS module must be in the catalog')
  }

  if $ensure == 'Present' {
    if $website_source == undef {
      $recurse = false
    } else {
      $recurse = true
    }

    file { $website_path:
      ensure  => directory,
      source  => $website_source,
      recurse => $recurse,
      before  => Dsc_xwebapppool[$pool_name],
    }

    if $website_directory_acl {#or ! empty($website_directory_acl) {
      acl { $website_path:
        * => $website_directory_acl,;
      }
    } else {
      acl { $website_path:
        inherit_parent_permissions => false,
        purge                      => false,
        permissions                => [
          {
            identity    => $directory_owner,
            rights      => ['read','execute'],
            perm_type   => 'allow',
            child_types => 'all',
            affects     => 'all',
          },
          {
            identity    => "IIS APPPOOL\\${pool_name}",
            rights      => ['read','execute'],
            perm_type   => 'allow',
            child_types => 'all',
            affects     => 'all',
          },
          {
            identity    => 'BUILTIN\Users',
            rights      => ['read'],
            perm_type   => 'allow',
            child_types => 'all',
            affects     => 'all',
          },
        ],
      }
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
    dsc_ensure       => $ensure,
    dsc_name         => $website_name,
    dsc_state        => $state,
    dsc_physicalpath => $website_path,
    dsc_bindinginfo  => $binding_hash,
  }

  if $app_name {

    dsc_xwebapplication { $app_name:
      dsc_ensure       => $app_ensure,
      dsc_name         => $app_name,
      dsc_physicalpath => $app_path,
      dsc_webapppool   => $pool_name,
      dsc_website      => $website_name,
      require          => Dsc_xwebsite[$website_name],
    }
  }

}
