#

define iis:website (
  String $website_name             = $title,
  Enum['Present','Absent'] $ensure = 'Present',
  Enum['Stopped','Started'] $state = 'Started',
  String $website_path             = "C:\\inetpub\\${website_name}",
) {

  dsc_xwebsite { $website_name:
    dsc_ensure        => $ensure,
    dsc_name          => $website_name,
    dsc_state         => $state,
    dsc_physicalpath  => $website_path,
  }

}
