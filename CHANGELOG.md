# CHANGELOG

## 8.0.0 - *2021-05-12*

- Chef 17 compatibility changes - [@bmhughes](https://github.com/bmhughes)
  - All resources now run with `unified_mode true`

## 7.3.0 - *2021-03-30*

- Fix generating multiple actions from the service resource - [@bmhughes](https://github.com/bmhughes)

## 7.2.1 - *2020-11-19*

- Enhance the pre-service action configuration test to remove compile/converge bug - [@bmhughes](https://github.com/bmhughes)

## 7.2.0 (2020-07-10)

- resolved cookstyle error: libraries/helpers.rb:120:44 refactor: `ChefCorrectness/InvalidPlatformInCase`
- resolved cookstyle error: libraries/helpers.rb:154:24 refactor: `ChefCorrectness/InvalidPlatformFamilyInCase`
- resolved cookstyle error: libraries/helpers.rb:161:14 refactor: `ChefCorrectness/InvalidPlatformFamilyInCase`
- resolved cookstyle error: libraries/helpers.rb:193:44 refactor: `ChefCorrectness/InvalidPlatformInCase`
- Fix the service resource not using the unit file content property
- Slightly simplified the libraries with a platform helper
- Fix verification of the isc-dhcp-server configuration on Ubuntu
- Ensure that a service restart does not occur upon a configuration test failure

## 7.1.1 (2020-05-20)

- Fix configuration test running every chef run regardless of service action - [@bmhughes](https://github.com/bmhughes)

## 7.1.0 (2020-05-18)

- Add configuration test option to the `dhcp_service` resource - [@bmhughes](https://github.com/bmhughes)

## 7.0.0 (2020-04-17)

Version 7.0.0 is a **major** change! Please see [UPGRADING.md](./UPGRADING.md).

- DHCPv6 server configuration support - [@bmhughes](https://github.com/bmhughes)
- Migrated to github actions - [@Xorima](https://github.com/Xorima)
- Remodel cookbook as resource library - [@bmhughes](https://github.com/bmhughes)
- Remove - [@bmhughes](https://github.com/bmhughes)
  - Attributes
  - Recipes
  - Data bag functionality
- Add resources to manage install and services for dhcpd/dhcpd6 - [@bmhughes](https://github.com/bmhughes)
- Rewrite resources to current standard removing pure ruby code - [@bmhughes](https://github.com/bmhughes)

## 6.1.0 (2019-10-19)

- Added ability to add extra custom lines to pool config <https://github.com/sous-chefs/dhcp/issues/117>
- Converted all LWRPs to Custom Resources
- Ran latest cookstyle fixes
- Migrated testing to circleci

## 6.0.0 (2018-03-04)

- Remove matchers. Breaking change. This requires ChefDK 2.0+
- Allow specifying array of `allow` and `deny` declarations in `dhcp_subnet` `pool`
- Convert to custom resources
- Drop support for Chef 12
- Add support for Fedora

## 5.5.0 (2018-03-04)

- Use Berkshelf instead of Policyfiles
- Remove support for RHEL5

## 5.4.4 (2018-03-04)

- Use dokken images for travis testing

## 5.4.3 (2018-03-04)

- Require Chef 12.7+ for `apt_update` fix

## 5.4.2 (2017-12-02)

- Remove Chef 10/11 compatibility code that resulted in Foodcritic deprecation warnings
- Fix misplaced closing brace for dhcpd hooks in template file

## 5.4.1

- Fix: attribute breaking Chef 13 runs.

## 5.4.0

- Added hooks

## 5.3.2

- bug #67: Removed blank? from helper libraries but was still calling in code. Addressed by removing blank? calls from code and using empty? instead.

## 5.3.1

- bug: Update `_hosts` recipe for `Helpers::DataBags.escape_bagname` change to `Dhcp::Helpers.escape`

## 5.3.0

- Remove dependencies on helper cookbooks

## 5.2.0

- Add `allow` attribute for `pool` in `dhcp_subnet` provider

## 5.1.0

- Allow specifying with `node['dhcp']['extra_files']` externally managed configs to load

## 5.0.3

- bug: Load classes before subnets

## 5.0.2

- bug: Include classes.d/list.conf in dhcp.conf
- bug: Make `dhcp_subnet` names declared in `dhcp_shared_network` more unique

## 5.0.1

- bug: Pin partial templates to dhcp cookbook

## 5.0.0

- BREAKING feature: Allow defining multiple pools in a subnet

  - This moves `range` and `peer` attribtue from `dhcp_subnet` block to embedded `pool` block inside `dhcp_subnet`. See updated examples.
  - Currently this DOES NOT break defining subnets via data_bags or node attributes

## 4.1.2

- bug: Allow defining dhcp_class with no subclasses

## 4.1.1

- improve: Add dhcp_class ChefSpec matcher

## 4.1.0

- feature: dhcp_class provider

## 4.0.1

- fix: be able to declare a blank subnet inside a shared-network

## 4.0.0

- feature: dhcp_shared_network provider to define subnets inside a shared-network block
- improve: allowing as blank as possible of a subnet block
- improve: setting next-server in a subnet block
- improve: allow dhcp_subnet range to be set with a String
- improve: documentation
- fix: including dhcp_host config files
- fix: Chef 12 support
- fix/improve: testing

## 3.0.0

- feature: allow setting multiple ranges in subnets. The range param now HAS to be an array, existing cooks will not work.
- improve: hostname in group configs is no long forced instead you can specify this in paramaters you pass.

## 2.2.2

- fix: Debian system have Chef with version Chef: 11.10.0.rc.1 that Chef::Version doesn't detect correctly
- fix: handle case where peer is unavailable on cluster start
- improve: better chef-solo support
- feature: Allow setting slaves and masters in attributes.
- feature: Added ability to pass eval into subnets

## 2.2.1

- support attribute driven mode, where no databags are needed to operate
- feature: add evals to groups
- fix error in subnet provider caused by mis-merged comma :(

## 2.1.2

- change write_config to write_include, write_config doesn't work on ubuntu 12.04
- allow you to set ddns-domainname for each subnet
- convert "not if"'s to "unles"
- Cleanup Readme for readability and attribution
- update contributors

## 2.1.1

- add tailor cane, kitchen testing
- chef specs for chefspec 3.0
- allow ddns update in subnet (pull request #13 from simonjohansson)
- fixes for chef11 compatibility
- fix version check in DSL condition
- update service notifications to new format

## 2.0.0

- Initial public release
- Restructure entire cookbook for better reusability
- Remove Internal/non-public dependencies
- Fix: master/slave replication issues
- Fix: LWRP notification method
- Add minimal spec's for libraries
- New: examples directory with databags and environments
- New: configurable bag lookups for dhcp/dns bags
- New: Group host list support
- New: Defaults to mac address as hostname for non registered clients
- New: Defines global defaults in default attributes
