# Beergeek-iis

## NOTE
This module uses the `puppetlabs-dsc` module and therefore requires `Windows Management Framework 5`.

#### Table of Contents

1. [Module Description](#module-description)
1. [Requirements](#requirements)
1. [Usage](#usage)
1. [Reference](#reference)
    * [Public Classes](#public-classes)
    * [Defined Types](#private-defined-types)
    * [Parameters](#parameters)
1. [Limitations](#limitations)

## Module Description

This module enables the IIS feature and managed websites with application pool and web applications.

The `iis` class will also enable `ASP`, `ASP.Net4.5`, `IIS Management Console` and `IIS Scripting Tools`.

## Usage
This module works with IIS7 and greater.

To add the role of IIS Webserver to the node you can simply call the `iis` class:

```puppet
include iis
```
To create a website with an application pool (having the same name as the site) the following can be done:

```puppet
iis::website { 'mysite.com.au': }
```

To create a website, with application pool and a web application the following can be done:

```puppet
iis::website { 'mysite.com.au':
  pool_name       => 'mypool',
  app_name        => 'myapp',
  website_source  => 'puppet:\\\iis_files\myapp',
}
```

This will create a website called `mysite.com.au`, an application pool called `mypool`, and a web application called `myapp`.  The website directory will contain the files and directories within the `puppet:\\\iis_files\myapp` fileserver mount point.

## Reference

### Public Classes
* [`iis`](#iis) Class to manage `IIS`, `ASP`, `ASP.Net4.5`, `IIS Management Console` and `IIS Scripting Tools`

### Defined Types
* [`iis::website`](#iiswebsite) Manages websites, application pools and web applications.

### Parameters

####iis
no parameters

####iis::website
#####`website_name`

**(required)** Name of the website.  Defaults to `$title`

#####`pool_name`

**(required)** The of application pool. Defaults to `$title`.

#####`directory_owner`

**(required)** SID or name of website directory owner. Defaults to `S-1-5-17`.

#####`app_name`

Name of web application. If `undef` the web application is not created. Default is `undef`.

#####`ensure`

**(required)** Determine if website is created or removed. Valid values are `Present` or `Absent`.  Default is `Present`.

#####`app_ensure`

**(required)** Determine if web application is created or removed, if `app_name` is used. Valid values are `Present` or `Absent`. Default to `Present`.

#####`state`

**(required)** Determine if website is started or stopped. Valid values are `Stopped` or `Started`. Default is `Started`.

#####`website_path`

**(required)** Path for website. Defaults to `C:\\inetpub\\${website_name}`.

#####`app_path`

**(required)** Path for web application. Defaults to `C:\\inetpub\\${website_name}`.

#####`website_source`

Source for website to be used in `file` resource.  Will recurse if provided. Default is `undef`.

#####`restart_mem_max`

**(required)** The limit for restart memory for Application Pool. Default is `1000`.

#####`restart_priv_mem_max`

**(required)** The limit for the restart private memory for the Application Pool. Default is `1000`.

#####`binding_hash`

**(required)** Array of hashes for binding information for website. Default is `[{ protocol => 'HTTP', port => 80, hostname => $title }]`.

## Limitations

Tested on Windows 2012r2
