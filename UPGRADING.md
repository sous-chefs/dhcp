# Upgrading

This document will give you help on upgrading major versions of dhcp

## 7.0.0

Version 7.0.0 is a major rewrite of the cookbook to current standards, remodelling as a resource library cookbook and the addition of DHCPv6 support.

### Removed

- All attributes
- All recipes
  - Enumeration of resources from data bags with this cookbook is not longer supported, you will have to write your own wrapper cookbook if you
    depend on this functionality.
- Resource `dhcp_pool`
  - Pool verification is now provided by the `dhcp_subnet` resource

### Added

- Resource `dhcp_config` - [Documentation](./documentation/dhcp_config.md)
  - Replacement for the `_config` recipe
  - Global configuration
  - DHCP failover configuration
  - Configuration of service environment file

- Resource `dhcp_package` - [Documentation](./documentation/dhcp_package.md)
  - Replacement for the `_package` recipe
  - Installs the relevant packages for platform

- Resource `dhcp_service` - [Documentation](./documentation/dhcp_service.md)
  - Replacement for the `_service` recipe
  - Creates a systemd unit file for the platform
  - Controls service activation

### Changed

- Common
  - Custom resources have been rewritten in current style
  - Relevant resources have `options` and `parameters` properties to allow more flexible user defined configuration
  - Template files are overrideable with `cookbook` and `template` parameters to allow user template selection
  - `owner`, `group` and `mode` properties to control the resultant permissions and mode of the generated files
  - DHCPv6 support for all resources, use `ip_version` to select

- Resource `dhcp_class` - [Documentation](./documentation/dhcp_class.md)
  - `:delete` action added
  - `subclasses` are now specified via `Hash` rather than a `Block`

- Resource `dhcp_group` - [Documentation](./documentation/dhcp_group.md)
  - `:delete` action added

- Resource `dhcp_host` - [Documentation](./documentation/dhcp_host.md)
  - `:delete` action added
  - `hostname` property removed, specify it via `options`
  - `macaddress` property is renamed to `identifier`
  - `ipaddress` property is renamed to `address`

- Resource `dhcp_shared_network` - [Documentation](./documentation/dhcp_shared_network.md)
  - `:delete` action added
  - Subnets are provided via included nested `dhcp_subnet` resources
  - `subnets` are now specified via `Hash` rather than a `Block`

- Resource `dhcp_subnet` - [Documentation](./documentation/dhcp_subnet.md)
  - `:delete` action added
  - `broadcast`, `routers`, `ddns` and `next-server` properties have been removed, specify them via `options` and `parameters`
  - `pools` are now specified via `Hash` rather than a `Block`
