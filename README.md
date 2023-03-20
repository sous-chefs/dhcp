# DHCP Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/dhcp.svg)](https://supermarket.chef.io/cookbooks/dhcp)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/dhcp/master.svg)](https://circleci.com/gh/sous-chefs/dhcp)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs and configures ISC DHCP server in both DHCP and DHCPv6 mode.

- Supports setting up Master/Slave ISC DHCP failover (IPv4 only).
- Includes Support for DDNS
- Includes resources for managing:
  - Package installation
  - Service configuration and management
  - Global configuration
  - Hosts
  - Groups
  - Subnets
  - Shared subnets

Version 7.0.0 constitutes a major change and rewrite, please see [UPGRADING.md](./UPGRADING.md).

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Platforms

- Debian / Ubuntu
- RHEL/CentOS and derivatives
- Fedora and derivatives

## Requirements

- Chef 15.3+

## Usage

It is recommended to create a project or organization specific [wrapper cookbook](https://www.chef.io/blog/2013/12/03/doing-wrapper-cookbooks-right/) and add the desired custom resources to the run list of a node.

Example of a basic server listening on and issuing leases for the subnet `192.0.2.0/24`.

```ruby
dhcp_install 'isc-dhcp-server'

dhcp_service 'dhcpd' do
  ip_version :ipv4
  action [:create, :enable, :start]
end

dhcp_config '/etc/dhcp/dhcpd.conf' do
  allow %w(booting bootp unknown-clients)
  parameters(
    'default-lease-time' => 7200,
    'max-lease-time' => 86400,
    'update-static-leases' => true,
    'one-lease-per-client' => true,
    'authoritative' => '',
    'ping-check' => true
  )
  options(
    'domain-name' => '"test.domain.local"',
    'domain-name-servers' => '8.8.8.8, 8.8.4.4'
  )
  action :create
end

dhcp_subnet '192.0.2.0' do
  comment 'Basic Subnet Declaration'
  subnet '192.0.2.0'
  netmask '255.255.255.0'
  options [
    'routers 192.168.1.1',
  ]
  pool(
    'peer' => '192.168.0.2',
    'range' => '192.168.1.100 192.168.1.200'
  )
  parameters(
    'ddns-domainname' => '"test.domain"'
  )
end
```

## External Documentation

- <https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcpdconf>
- <https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcp-options>
- <https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcp-eval>

## Examples

Please check for more varied working examples in the [test cookbook](./test/cookbooks/test/).

## Resources

- [dhcp_class](documentation/dhcp_class.md)
- [dhcp_config](documentation/dhcp_config.md)
- [dhcp_group](documentation/dhcp_group.md)
- [dhcp_host](documentation/dhcp_host.md)
- [dhcp_package](documentation/dhcp_package.md)
- [dhcp_service](documentation/dhcp_service.md)
- [dhcp_shared_network](documentation/dhcp_shared_network.md)
- [dhcp_subnet](documentation/dhcp_subnet.md)

## Known Issues

There are some known issues on Ubuntu when apparmor is running which may prevent the service from running properly.
Please see the [test cookbook](test/cookbooks/test) for a possible work around that you can apply on your nodes.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
