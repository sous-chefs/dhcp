5.0.0
-----
* BREAKING feature: Allow defining multiple pools in a subnet
 * This moves `range` and `peer` attribtue from `dhcp_subnet` block to embedded `pool` block inside `dhcp_subnet`.  See updated examples.
 * Currently this DOES NOT break defining subnets via data_bags or node attributes

4.1.2
-----
* bug: Allow defining dhcp_class with no subclasses

4.1.1
-----
* improve: Add dhcp_class ChefSpec matcher

4.1.0
-----
* feature: dhcp_class provider

### 4.0.1
* fix: be able to declare a blank subnet inside a shared-network

### 4.0.0
* feature: dhcp_shared_network provider to define subnets inside a shared-network block
* improve: allowing as blank as possible of a subnet block
* improve: setting next-server in a subnet block
* improve: allow dhcp_subnet range to be set with a String
* improve: documentation
* fix: including dhcp_host config files
* fix: Chef 12 support
* fix/improve: testing

### 3.0.0 
_Breaking Changes_ 
* feature: allow setting multiple ranges in subnets. The range param now HAS to be an array, existing cooks will not work.
* improve: hostname in group configs is no long forced instead you can specify this in paramaters you pass. 

### 2.2.2
* fix: Debian system have Chef with version Chef: 11.10.0.rc.1 that Chef::Version doesn't detect correctly
* fix: handle case where peer is unavailable on cluster start
* improve: better chef-solo support
* feature: Allow setting slaves and masters in attributes.
* feature: Added ability to pass eval into subnets

### 2.2.1:
* support attribute driven mode, where no databags are needed to operate
* feature: add evals to groups
* fix error in subnet provider caused by mis-merged comma :(

### 2.1.2:
* change write_config to write_include, write_config doesn't work on ubuntu 12.04
* allow you to set ddns-domainname for each subnet
* convert "not if"'s to "unles"
* Cleanup Readme for readability and attribution
* update contributors

### 2.1.1:
* add tailor cane, kitchen testing
* chef specs for chefspec 3.0
* allow ddns update in subnet  (pull request #13 from simonjohansson)
* fixes for chef11 compatibility
* fix version check in DSL condition
* update service notifications to new format

### 2.0.0:
* Initial public release
* Restructure entire cookbook for better reusability
* Remove Internal/non-public dependencies  
* Fix: master/slave replication issues
* Fix: LWRP notification method
* Add minimal spec's for libraries
* New: examples directory with databags and environments
* New: configurable bag lookups for dhcp/dns bags
* New: Group host list support
* New: Defaults to mac address as hostname for non registered clients
* New: Defines global defaults in default attributes
