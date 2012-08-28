Description
===========
Configures a DHCP server.  Includes LWRPs for managing hosts, groups and subnets. 

If you need PXE-boot installations, you can use this cookbook with `pxe_dust` which will configure the `tftp` cookbook and prepare the bootable images.

Based off of work initially done by Dell, extended by Atalanta Systems and reworked by Opscode.

Requirements
============
Tested with Ubuntu 10.04 and Chef 0.10.

Limitations
===========
Pools, failovers, classes and subclasses are not yet supported.

Recipes
=======
default
-------
Passes through to the server.

server
------
The node will install and configure the `dhcp3-server` application. Configuration is through the `dhcp` data bag.

Data Bag
========
dhcp
----
Configuration for this service is through the `dhcp` data bag so other cookbooks and recipes may have access to this information as necessary. The configuration of the `dhcpd.conf` can either be done through attributes or through the `default` item in the data bag (data bag takes prescedence). 

```
% knife data bag create dhcp
% knife data bag from file dhcp examples/default.json
```

Resources/Providers
===================
host
----
This LWRP 

# Actions
- :add: 
- :remove: 

# Attribute Parameters

- key: 
- url: 

# Example

``` ruby
# add
    
# remove

```

group
-----
This LWRP 

# Actions
- :add: 
- :remove: 

# Attribute Parameters

- key: 
- url: 

# Example

``` ruby
# add
    
# remove

```

subnet
------
This LWRP 

# Actions
- :add: 
- :remove: 

# Attribute Parameters

- key: 
- url: 

# Example

``` ruby
# add
    
# remove

```

Usage
=====



License and Author
==================
Author:: Matt Ray (<matt@opscode.com>)

Copyright:: 2011 Atalanta Systems

Copyright:: 2011 Dell, Inc.

Copyright:: 2011 Opscode, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

