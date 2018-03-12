# The class enables the role of `IIS`, `ASP`, `ASP.Net4.5`, `IIS Management Console` and `IIS Scripting Tools`.
#
#
class iis (
) {

  if $::os['family'] != 'windows' {
    fail("This class is only for Windows, not for ${::os['family']}")
  }

  dsc_windowsfeature { 'IIS':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Server',
  }

  dsc_windowsfeature { 'ASP':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-ASP',
    require    => Dsc_windowsfeature['IIS'],
  }

  dsc_windowsfeature { 'ASP.Net_4.5':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Asp-Net45',
    require    => Dsc_windowsfeature['IIS'],
  }

  dsc_windowsfeature { 'IIS_Management_Console':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Mgmt-Console',
    require    => Dsc_windowsfeature['IIS'],
  }

  dsc_windowsfeature { 'IIS_Script_And_Tools':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Scripting-Tools',
    require    => Dsc_windowsfeature['IIS'],
  }

}
