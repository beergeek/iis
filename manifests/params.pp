#
class iis::params {

  if $::os['family'] != 'windows' {
    fail("This class is only for Windows, not for $::os['family']")
  }
}
