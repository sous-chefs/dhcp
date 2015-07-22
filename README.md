[![Build Status](https://secure.travis-ci.org/chef-brigade/dhcp-cookbook.png)](http://travis-ci.org/chef-brigade/dhcp-cookbook)

Description
===========
Data bag and Attribute driven DHCP server.

* Supports setting up Master/Master isc DHCP failover.
* Includes Support for ddns
* Includes LWRPs for managing hosts, groups and subnets.
* Use databags or attributes + wrapper cooks to manage dhcp server [Example](examples/attribute_driven.rb)

Large parts were borrowed from  work initially done by Dell, extended by Atalanta Systems and reworked by Matt Ray and Opscode. Big thanks to all of them.

Requirements
============
Tested on the following with Chef11:
* `Ubuntu 12.04`
* `CentOS 6`

Limitations
===========
* only setup to handle ipv4

Recipes
=======
default
-------
Stub recipe that does nothing. Good for including LWRP's but not the other recipe stuffs.

server
------
The node will install and configure the `dhcp-server` application.
Configuration is through various dhcp_X bags, and the current role/environment

Node Attributes
==========
Almost everyone of the parameters and options are able to be overrode in the
host/group/network scope these are general defaults for the server.

 Check out the [man page][1] for details on dhcpd.conf options/params.


| attribute | Type | Default | description |
|:---------------------------------|:----:|:------:|:-----------------------------------------|
|`node[:dhcp][:use_bags]` | `Boolean` | true | When false we won't attempt to load data from bags.
|`node[:dhcp][:hosts]` | `Array` | `[]` | The list of hosts items that this server should load
|`node[:dhcp][:groups]` | `Array` | `[]` | The list of group items this server should load
|`node[:dhcp][:networks]` | `Array` | `[]` | The list of network items this node should load
|`node[:dhcp][:interfaces]` | `Array` | `[]` | The Network Interface(s) to listen on. If an empty list then we will listen on all interfaces.
|`node[:dhcp][:rndc_keys]` | `Array` | Attribute based representation of rndc keys you want to use.
|`node[:dhcp][:hosts_bag]` | `String` | dhcp_hosts | The name of the data bag that holds host items.
|`node[:dhcp][:groups_bag]` | `String` | dhcp_groups | The name of the data bag that holds group items
|`node[:dhcp][:networks_bag]` | `String` | dhcp_networks | The name of the data bag that holds network items
|`node[:dhcp][:host_data]` | `Hash` | `{}` | Hash of hosts data. The `node[dhcp][:hosts]` entries should have a corresponding entry here when not using bags
|`node[:dhcp][:group_data]` | `Hash` | `{}` | Same as host_data, but for groups
|`node[:dhcp][:network_data]` | `Hash` | `{}` | Same as host_data, but for networks
|`node[:dhcp][:failover]` | `Boolean` | `false` | Enable Failover support buy setting to `true`
|`node[:dhcp][:failover_lease_hack]` | `Boolean` | `false` | Force partner-down state on start by rewriting lease file
|`node[:dhcp][:allows]` | `Array` | ["booting", "bootp", "unknown-clients"] | Global Dhcpd allow entries
|`node[:dhcp][:my_ip]` | `String` | Nil | Set host IP address in failover setup. node[:ipaddress] is used if empty.
|`node[:dhcp][:masters]` | `Array` | Array of hashes to override node search for masters. Must have :ipaddress key.
|`node[:dhcp][:slaves]` | `Array` | Array of hashes to override node search for slaves.

#### DHCP Global Options
| attribute | Type | Default | description |
|:---------------------------------|:----:|:------:|:-----------------------------------------|
|`node[:dhcp][:options]['domain-name-servers']` | `String` | "8.8.8.8, 8.8.4.4" |List of dns servers to send to clients in the global scope
|`node[:dhcp][:options]['host-name']` | `String` | " = binary-to-ascii (16, 8, \"-\", substring (hardware, 1, 6))" |Options for global scope host-name settings. The default here will generate a host as mac address if the node doesn't provide a hostname or is not defined in dns/hosts/groups.
|`node[:dhcp][:options]['domain-name']` | `String` | "\"#{domain}\"" | Set domainname  in the global scope to this nodes domain

#### DHCP Global Parameters
These are all just k/v entries in the global params hash. All values are type: `String`

| attribute | Type | Default | description |
|:---------------------------------|:----:|:------:|:-----------------------------------------|
|`node[:dhcp][:parameters]["default-lease-time"]` | `String` | "6400"| Set the default lease time in the global scope
|`node[:dhcp][:parameters]["ddns-domainname"]` | `String` | "\"#{domain}\""`| Set the ddns domain to this nodes domain
|`node[:dhcp][:parameters]["ddns-update-style"]` | `String` |"interim" | ddns Update style
|`node[:dhcp][:parameters]["max-lease-time"]` | `String` | "86400" | Max Lease time
|`node[:dhcp][:parameters]["update-static-leases"]` | `String` | "true" | Make sure we push static ip adresses defined in groups/hosts to the dns server
|`node[:dhcp][:parameters]["one-lease-per-client"]` | `String` | "true" | When a client requests an ip it will release any held leases.
|`node[:dhcp][:parameters]["authoritative"]` | `String` | "" | This setting has no value on purpose thats how isc-dhcpd wants it.
|`node[:dhcp][:parameters]["ping-check"]` | `String` | "true" | Enable Address collision checking
|`node[:dhcp][:parameters]["next-server"]` | `String` | `"#{ipaddress}"` |Set this server as the global next-server
|`node[:dhcp][:parameters]["filename"]` | `String` | `'"pxelinux.0"'` | For tftp file name __Note:__ the quotes are necessary for this option in the fall throught to dhcpd config.

#### Failover parameters
| attribute | Type | Default | description |
|:---------------------------------|:----:|:------:|:-----------------------------------------|
|`node[:dhcp][:failover_params]["mclt"]` | `String` | "3600"| Set Maximum Client Lead Time
|`node[:dhcp][:failover_params]["port"]` | `String` | "647"| TCP port to listen for connections from peer
|`node[:dhcp][:failover_params]["peer_port"]` | `String` | "647"| TCP port to connect to failover peer
|`node[:dhcp][:failover_params][auto_partner_down""]` | `String` |"0"| Timeout in seconds to enter partner-down state if peer is unavailable

#### Platform Default Attributes
*RHEL* Platforms*

| attribute | Type | Default |
|:---------------------------------|:----:|:------:|
|`node[:dhcp][:dir]`           |`String` | `"/etc/dhcpd"`
|`node[:dhcp][:package_name]`  |`String` | `"dhcp"`
|`node[:dhcp][:service_name]`  |`String` | `"dhcpd"`
|`node[:dhcp][:config_file]`   |`String` | `"/etc/dhcp/dhcpd.conf"` on `RHEL < 6` it defaults to `"/etc/dhcpd.conf`
|`node[:dhcp][:init_config]` |`String` | `"/etc/sysconfig/dhcpd"`


*Debian Platforms*

| attribute | Type | Default |
|:---------------------------------|:----:|:------:|
|`node[:dhcp][:dir]`         | `String` | "/etc/dhcpd"
|`node[:dhcp][:package_name]`| `String` | "isc-dhcp-server"
|`node[:dhcp][:service_name]`| `String` | "isc-dhcp-server"
|`node[:dhcp][:config_file]` | `String` | "/etc/dhcp/dhcpd.conf"
|`node[:dhcp][:init_config]` | `String` | "/etc/default/isc-dhcp-server"


Data Bags
========
Data bags drive the lionshare of the dhcp configuration. Beyond the global settings. It is not required to configure
any bags other than dhcp_networks to get up and running, But if you want to statically map a network or have handy
Host names provisioned by dhcp you will have to add either `dhcp_groups/dhcp_hosts` bags and items.

You can generate example bags by using these handy commands

```
knife data bag create dhcp_networks
knife data bag create dhcp_groups
knife data bag create dhcp_hosts
knife data bag from file dhcp_networks examples/data_bags/dhcp_networks
knife data bag from file dhcp_groups examples/data_bags/dhcp_groups
knife data bag from file dhcp_hosts examples/data_bags/dhcp_hosts
```

dhcp_networks
-------------
Looked up via `node[:dhcp][:networks_bag]`. Describes networks this dhcp server should be configured to provide services for.
Per-network options can be provided as an array of strings where each string is a dhcp option.
Make sure you escape `"`'s properly as dhcpd is touchy about the format of values.

```json
{
  "id": "192-168-1-0_24",
  "routers": [ "192.168.1.1" ],
  "address": "192.168.1.0",
  "netmask": "255.255.255.0",
  "broadcast": "192.168.1.255",
  "range": "192.168.1.50 192.168.1.240",
  "options": [ "time-offset 10" ],
  "next_server": "192.168.1.11"
}
```

dhcp_groups
----------
Looked up via `node[:dhcp][:grougroups]` Items for this bag are group entries as per the [man page][1].
Groups are sets of machines that can be configured with common parameters.  A group can be bare. I.e.
Contains no host or parameters entries whatsover, and just defines options.


The only required key in a host def is the `"mac":` key. Everything else is optional

Example Group Bag
```json
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
```

There are a few keys that merit more discussion:
## `"hosts":` key dhcp_group Items
Groups in isc-dhcp can define lists of hosts. In this example we are using the `use-host-decl-names on`
tell dhcp to use the "some-vm" and "another-host" entries as the host-name for these clients.
As well as setting other per-group parameters.

Each Host in the hosts Hash can have a number of settings, but the only required setting is `"mac":` the mac address
for the host.


| Key | Description  |
|:---------------|:------|
|`"mac":` | mac address of this host
|`"ip":`  | ip address of this host
|`"parameters":` |an array of isc-dhcpd parameters as-per the global parameter setting.
|`"pxe":` |This key is used by my pxe cookbook to figure out what pxe item  you want this group to boot too. That Pxe cookbook should be released soon (hopefully).


dhcp_hosts
----------
Dhcp hosts bag is looked up via  `node[:dhcp][:hosts_bag]`, and contains Host Items.

Example Most Basic host:

```json
{
  "id": "vagrant-vm",
  "hostname": "vagrant.vm",
  "mac": "08:00:27:f1:1f:b6",
}
```

Example Complex host:
```json
{
  "id": "pxe_test-vm",
  "hostname": "pxe_test.vm",
  "mac": "08:00:27:8f:7b:db",
  "ip": "192.168.1.31",
  "parameters": [ ],
  "options": [ ],
  "pxe": "ubuntu-precise"
}
```

Resources/Providers
===================
## dhcp_host

Manipulate host entries in dhcpd

### Actions

| Action | Description |
|:----------|:---------|
| `add`    | `_default_` Add this host record
| `remove` | Delete this host record

### Paramaters
| Param | Type | Default |
|:----------|:---------|:-------|
| `hostname`   | `String`
| `macaddress` | `String`
| `ipaddress`  | `String` |
| `options`    | `Array`  | `[]`
| `parameters` | `Array`  | `[]`
| `conf_dir`   | `String` | `"/etc/dhcp"`

### Example

Add a Node
```ruby
dhcp_host "myhost" do
  hostname   "somebox.foobar.com"
  macaddress "08:00:27:f1:1f:b6"
  ipaddress  "192.168.1.22"
  options   [ "domain-name-servers 8.8.8.8" ]
end
```

Remove a node
```ruby
dhcp_host "myhost" do
  action :remove
  hostname "somebox.foobar.com"
end
```

If you undefine an entry it will also get removed.


## dhcp_group

### Actions

| Action | Description |
|:----------|:---------|
| `add`    | `_default_` Add this host record
| `remove` | Delete this host record

### Paramaters

| Param | Type | Default | Desciption |
|:----------|:----|:----|:------------|
| `name`      | `String`| `:name_attribute`
| `hosts`     | `Hash`  | `{}` | This is a hash of host entries that follow the host-databag format. See the example entry in examples directory
| `parameters`| `Array` |  `[]`
| `evals`| `Array` |  `[]` | This is an array of multiline strings of eval
| `conf_dir`  | `String`| `"/etc/dhcp"` | The directory where the config files are stored

### Example

```ruby
hosts_data = {
  "some-vm"=> {"parameters"=>[], "mac"=>"11:22:33:44:55:66", "ip"=>"192.168.1.111"},
  "another-host"=>{"mac"=>"22:33:44:55:66:77"}}
}

dhcp_group "some_group" do
  parameters [ "default-lease-time 120", "next-server \"someplace\""]
  hosts hosts_data
end
```

## dhcp_subnet

| Action | Description |
|:----------|:---------|
| `add`    | `_default_` Add this host record
| `remove` | Delete this host record

### Paramaters

| Param | Type | Default | Desciption |
|:----------|:----|:----|:------------|
| `subnet` | `String` | `:name_attribute` | The network subnet
| `broadcast`| `String` | `nil` | The broadcast address for the subnet
| `netmask` | `String` | `nil` | The netmask address for the subnet
| `routers` | `Array`| `[]` | Gateways for the subnet
| `options` | `Array`| `[]` | DHCP options to set for the subnet
| `range` | `Array` | `[]` | Range of IPs to make available for DHCP in the subnet
| `next_server` | `String` | `nil` | Next server for TFTP/PXE
| `peer` | `String` | `nil` | Peer server for this segment
| `evals` | `Array` |  `[]` | This is an array of multiline strings of eval
| `ddns` | `String` | `nil` | Domain name that will be appended to the client's hostname to form a fully-qualified domain-name (FQDN)
| `key` | `Hash` | `{}` | Shared secret key for DDNS
| `zones` | `Array` | `[]` | _NOTE: Please help update with a good description_
| `conf_dir` |`String` | `"/etc/dhcp"` | Main dhcpd config directory

### Example
```ruby
dhcp_subnet "192.168.1.0" do
  range ["192.168.1.100 192.168.1.200", "10.33.66.10 10.33.66.100"]
  netmask "255.255.255.0"
  broadcast "192.168.1.255"
  options [ "time-offset 10" ]
  next_server "192.168.1.11"
  routers "192.168.1.1"
  evals [ %q|
    if exists user-class and option user-class = "iPXE" {
      filename "bootstrap.ipxe";
    } else {
      filename "undionly.kpxe";
    }
  | ]
end
```

## dhcp_shared_network

| Action | Description |
|:----------|:---------|
| `add`    | `_default_` Add this shared network
| `remove` | Delete this shared network record

### Paramaters

| Param | Type | Default | Desciption |
|:----------|:----|:----|:------------|
| `subnet` | `dhcp_subnet` |  `nil` | The network subnet to define inside the shared network.  Can define multiple.

### Example
```ruby
dhcp_shared_network 'mysharednet' do
  subnet '192.168.1.0' do
    range ['192.168.1.100 192.168.1.200', '10.33.66.10 10.33.66.100']
    netmask '255.255.255.0'
    broadcast '192.168.1.255'
    next_server '192.168.1.11'
    routers '192.168.1.1'
    evals [ %q|
      if exists user-class and option user-class = "iPXE" {
        filename "bootstrap.ipxe";
      } else {
        filename "undionly.kpxe";
      }
    | ]
  end
  subnet '10.0.2.0' do
    broadcast '10.0.2.254'
    netmask '255.255.255.0'
    range ['10.0.2.50 10.0.2.240']
  end
end
```

License and Author
==================

### Originally forked from
https://github.com/spheromak/dhcp-cook

### Maintainer, Authors and Contributors

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Maintainer**       | [Jacob McCann](https://github.com/jmccann)
| **Original Author**  | [Jesse Nelson](https://github.com/spheromak)
| **Author**           | [Matt Ray](https://github.com/mattray)
| **Contributor**      | [Myles Steinhauser](https://github.com/masteinhauser)
| **Contributor**      | [Bao Nguyen](https://github.com/sysbot)
| **Contributor**      | [Chaman Kang](https://github.com/chamankang)
| **Contributor**      | [Will Reichert](https://github.com/wilreichert)
| **Contributor**      | [Simon Johansson](https://github.com/simonjohansson)
| **Contributor**      | [Robert Choi](https://github.com/robertchoi8099)
| **Contributor**      | [Hippie Hacker](https://github.com/hh)
| **Contributor**      | [Eric Blevins](https://github.com/e1000)
| **Copyright** | Copyright (c) 2013 Jesse Nelson
| **Copyright** | 2011 Atalanta Systems
| **Copyright** | 2011 Dell, Inc.
| **Copyright** | 2011 Opscode, Inc.

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
