Description
===========
Data bag and environment drivent DHCP server. 

* Supports setting up Master/Master isc DHCP failover.  
* Includes Support for ddns 
* Includes LWRPs for managing hosts, groups and subnets.

Large parts were borrowed from  work initially done by Dell, extended by Atalanta Systems and reworked by Matt Ray and Opscode. Big thanks to all of them. 

Requirements
============
Tested on `Ubuntu 12.04` `CentOS 6` using Chef 10+

Limitations
===========
* only setup to handle ipv4
* no generic classification support
* ddns is tied to dns_zones databags 


Recipes
=======
default
-------
Stubb recipe that does nothing. Good for including LWRP's but not the other recipe stuffs. 

server
------
The node will install and configure the `dhcp-server` application. 
Configuration is through various dhcp_X bags, and the current role/environment 

Node Attributes
==========
Allmost everyone of the parameters and options are able to be overode in the 
host/group/network scope these are general defaults for the server. 

 Check out the [man page][1] for details on dhcpd.conf options/params.

##  Attribute - _Type_ - Default
## `node[:dhcp][:hosts_bag]` - `String` - `"dhcp_hosts"`
The name of the data bag that holds host items

## `node[:dhcp][:networks_bag]` - `String` - `"dhcp_networks"`
The name of the data bag that holds network items

## `node[:dhcp][:groups_bag]` - `String` - `"dhcp_groups"`
The name of the data bag that holds group items

## `node[:dhcp][:hosts]` - `Array` - `[]`
The list of hosts items that this server should load 

## `node[:dhcp][:groups]` - `Array` - `[]`
The list of group items this server should load 

## `node[:dhcp][:networks]` - `Array` - `[]`
The list of network items this node shoul load

## `node[:dhcp][:interfaces]` - `Array` - `[]`
The Network Interface(s) to listen on. If an empty list then we will listen on all interfaces.

## `node[:dhcp][:failover]` - `Boolean` -  `false`
Enable Failover support buy setting to `true`

## `node[:dhcp][:allows]` - `Array` - `[ "booting", "bootp", "unknown-clients" ]`
Set global Dhcpd allow entries 

### `node[:dhcp][:options]` Global Options 
## `node[:dhcp][:options]['domain-name-servers']` - `String` - `"8.8.8.8, 8.8.4.4"`
List of dns servers to send to clients in the global scope 

## `node[:dhcp][:options]['host-name']` - `String` `" = binary-to-ascii (16, 8, \"-\", substring (hardware, 1, 6))"`
Options for global scop host-name settings. The default here will generate a host as mac address if the node doesn't provide a hostname or is not defined in dns/hosts/groups.

## `node[:dhcp][:options]['domain-name']` - `String` - `"\"#{domain}\""`
Set domainname  in the global scope to this nodes domain 


### `node[:dhcp][:parameters]` Global Parameters
These are all just k/v entries in the global params hash. All values are type: `String`
## `node[:dhcp][:parameters]["default-lease-time"]` - `String` -  `"6400"`
Set the default lease time in the global scope

## `node[:dhcp][:parameters]["ddns-domainname"]` - `String` - "\"#{domain}\""`
Set the ddns domain to this nodes domain

## `node[:dhcp][:parameters]["ddns-update-style"]` - `String` - `"interim"`
ddns Upadte style

## `node[:dhcp][:parameters]["max-lease-time"]` - `String` - `"86400"`
Max Lease time

## `node[:dhcp][:parameters]["update-static-leases"]` - `String` - `"true"`
Make sure we push static ip adresses defined in groups/hosts to the dns server

## `node[:dhcp][:parameters]["one-lease-per-client"]` - `String` - `"true"`
When a client requests an ip it will release any held leases.

## `node[:dhcp][:parameters]["authoritative"]` - `String` - `""`
This setting has no value on purpose thats how isc-dhcpd wants it.

## `node[:dhcp][:parameters]["ping-check"]` - `String` - `"true"`
Enable Adress collision checking

## `node[:dhcp][:parameters]["next-server"]` - `String` - `"#{ipaddress}"`
Set this server as the global next-server

## `node[:dhcp][:parameters]["filename"]` - `String` - `'"pxelinux.0"'`
For tftp file name __Note:__ the quotes are nessicary for this option in the fall throught to dhcpd config.


### Platform Default Attributes

### RHEL
## `node[:dhcp][:dir]` - `String` - `"/etc/dhcpd"`
## `node[:dhcp][:package_name]` - `String` - `"dhcp"`
## `node[:dhcp][:service_name]` - `String` - `"dhcpd"`
## `node[:dhcp][:config_file]`  - `String` - `"/etc/dhcp/dhcpd.conf"`
 on `RHEL < 6` it defaults to `"/etc/dhcpd.conf`
## `node[:dhcp][:init_config]`  - `String` - `"/etc/sysconfig/dhcpd"`


### Debian
## `node[:dhcp][:dir]` - `String` - `"/etc/dhcpd"`
## `node[:dhcp][:package_name]` - `String` - `"isc-dhcp-server"`
## `node[:dhcp][:service_name]` - `String` - `"isc-dhcp-server"`
## `node[:dhcp][:config_file]`  - `String` - `"/etc/dhcp/dhcpd.conf"`
## `node[:dhcp][:init_config]`  - `String` - `"/etc/default/isc-dhcp-server"`


Data Bags
========
Data bags drive the lionshare of the dhcp configuration. Beyond the global settings. It is not required to configure 
any bags other than dhcp_networks to get up and running, But if you want to statically map a network or have handy 
Host names provisioned by dhcp you will have to add either dhcp_groups/dhcp_hosts bags and items. 

You can generate example bags by using these handy commands

    % knife data bag create dhcp_networks
    % knife data bag create dhcp_groups
    % knife data bag create dhcp_hosts
    % knife data bag from file dhcp_networks examples/data_bags/dhcp_networks
    % knife data bag from file dhcp_groups examples/data_bags/dhcp_groups
    % knife data bag from file dhcp_hosts examples/data_bags/dhcp_hosts



dhcp_networks  
-------------
Looked up via `node[:dhcp][:networks_bag]`. Describes networks this dhcp server should be configured to provide services for. 
Per-network options can be provided as an array of strings where each string is a dhcp option. 
Make sure you escape `"`'s properly as dhcpd is touchy about the format of values. 

    {
      "id": "192-168-1-0_24",
      "routers": [ "192.168.1.1" ],
      "address": "192.168.1.0",
      "netmask": "255.255.255.0",
      "broadcast": "192.168.1.255",
      "range": "192.168.1.50 192.168.1.240",
      "options": [ "next-server 192.168.1.11" ]
    }


dhcp_groups
----------
Looked up via `node[:dhcp][:grougroups] Items for this bag are group entries as per the [man page][1].
Groups are sets of machines that can be configured with common parameters.  A group can be bare. I.e. 
Contains no host or parameters entries whatsover, and just defines options.


The only required key in a host def is the `"mac":` key. Everything else is optional

Example Group Bag
        {
          "id": "test",
          "pxe":  "ubuntu-precise",
          "parameters": [
            "use-host-decl-names on",
            "max-lease-time 300",
            "default-lease-time 120",
            "next-server \"someplace\""
          ],
          "hosts": {
            "some-vm": {
              "parameters": [  ],
              "mac": "11:22:33:44:55:66",
              "ip": "192.168.1.111"
            },
            "another-host": {
              "mac": "22:33:44:55:66:77"
            }
          }
        }



There are a few keys that merit more discussion: 
## `"hosts":` key dhcp_group Items
Groups in isc-dhcp can define lists of hosts. In this example we are using the `use-host-decl-names on`
tell dhcp to use the "some-vm" and "another-host" entries as the host-name for these clients.
As well as setting other per-group parameters. 

Each Host in the hosts Hash can have a number of settings, but the only required setting is `"mac":` the mac address
for the host.  

### `"mac":` 
mac address of this host
### `"ip":`
ip address of this host
### `"parameters":` 
an array of isc-dhcpd parameters as-per the global parameter setting. 


## `"pxe":` 
This key is used by my pxe cookbook to figure out what pxe item  you want this group to boot too. That Pxe cookbook should be released soon (hopefully).


dhcp_hosts
----------
Dhcp hosts bag is looked up via  `node[:dhcp][:hosts_bag]`, and contains Host Items. 

Example Most Basic host:

    {
      "id": "vagrant-vm",
      "hostname": "vagrant.vm",
      "mac": "08:00:27:f1:1f:b6",
    }


Example Complex host: 

    {
      "id": "pxe_test-vm",
      "hostname": "pxe_test.vm",
      "mac": "08:00:27:8f:7b:db",
      "ipaddress": "192.168.1.31",
      "parameters": [ ],
      "options": [ ],
      "pxe": "ubuntu-precise"
    }



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



License and Author
==================
Author:: Jesse Nelson (<spheromak@gmail.com>)
Author:: Matt Ray (<matt@opscode.com>)

Copyright:: 2012 Jesse Nelson
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

[1]: http://www.daemon-systems.org/man/dhcpd.conf.5.html "dhcpd.conf man page"

