# Beergeek-iis

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

## Requirements

This module uses the `puppetlabs-dsc` module and therefore requires `Windows Management Framework 5`.

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
* [`iis`](#iis): The class enables the role of `IIS`, `ASP`, `ASP.Net4.5`, `IIS Management Console` and `IIS Scripting Tools`.
## Defined types
* [`iis::website`](#iiswebsite): The defined type manages websites, website directory, app pools, and web applications.
## Classes

### iis

The class enables the role of `IIS`, `ASP`, `ASP.Net4.5`, `IIS Management Console` and `IIS Scripting Tools`.


## Defined types

### iis::website

The defined type manages websites, website directory, app pools, and web applications.


#### Parameters

The following parameters are available in the `iis::website` defined type.

##### `app_ensure`

Data type: `Enum['Present','present','Absent','absent']`

Determine if web application is created or removed, if `app_name` is used.

Default value: 'Present'

##### `app_path`

Data type: `Optional[String]`

Path for web application.

Default value: "C:\\inetpub\\${app_name}"

##### `binding_hash`

Data type: `Array[Hash]`

Array of hashes for binding information for website.

Default value: [{ protocol => 'HTTP', port => 80, hostname => $title }]

##### `directory_owner`

Data type: `String`

SID or name of website directory owner.

Default value: 'S-1-5-17'

##### `ensure`

Data type: `Enum['Present','present','Absent','absent']`

Determine if website is created or removed.

Default value: 'Present'

##### `pool_name`

Data type: `String`

The of application pool.

Default value: $title

##### `restart_mem_max`

Data type: `Integer`

The limit for restart memory for Application Pool.

Default value: 1000

##### `restart_priv_mem_max`

Data type: `Integer`

The limit for the restart private memory for the Application Pool.

Default value: 1000

##### `state`

Data type: `Enum['Stopped','stopped','Started','started']`

Determine if website is started or stopped.

Default value: 'Started'

##### `website_name`

Data type: `String`

The name of the website.

Default value: $title

##### `website_source`

Data type: `Optional[String]`

Source for website to be used in `file` resource.  Will recurse if provided.

Default value: `undef`

##### `app_name`

Data type: `Optional[String]`

Name of web application.

Default value: `undef`

##### `website_directory_acl`

Data type: `Optional[Hash]`

A hash of the ACL for the website directory. Remember Puppet cannot explicitly manage inherited permissions.

Default value: `undef`

##### `website_path`

Data type: `String`

Path for website.

Default value: "C:\\inetpub\\${website_name}"
## Limitations

Tested on Windows 2012r2
