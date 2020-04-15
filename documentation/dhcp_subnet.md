# dhcp_subnet

[Back to resource list](../README.md#resources)

Create and manage the main DHCPD configuration. (<https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcpdconf>)

Introduced: v7.0.0

## Actions

- `:create`
- `:delete`

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `comment`              | String        | `nil`                            | Comment to add to the configuration file                            |                     |
| `ip_version`           | Symbol        | `:ipv4`                          | Select DHCP or DHCPv6 server to configure                           | `:ipv4`, `:ipv6`    |
| `conf_dir`             | String        | `/etc/dhcp/dhcpd(6).d/classes.d` | Directory to create configuration file in                           |                     |
| `cookbook`             | String        | `/etc/dhcp/dhcpd(6).d/classes.d` | Cookbook to source configuration file template from                 |                     |
| `template`             | String        | `/etc/dhcp/dhcpd(6).d/classes.d` | Template to use to generate the configuration file                  |                     |
| `owner`                | String        | Platform dependant               | Owner of the generated configuration file                           |                     |
| `group`                | String        | Platform dependant               | Group of the generated configuration file                           |                     |
| `mode`                 | String        | `'0640'`                         | Filemode of the generated configuration file                        |                     |
| `shared_network`       | True, False   | `false`                          | DHCP failover configuration file path                               |                     |
| `subnet`               | String        | `nil`                            | Subnet address                                                      |                     |
| `netmask`              | String        | `nil`                            | Subnet network for IPv4 subnets                                     |                     |
| `prefix`               | String        | `nil`                            | Subnet prefix for IPv6 subnets                                      |                     |
| `subnet`               | String        | `nil`                            | Subnet address                                                      |                     |
| `subnet`               | String        | `nil`                            | Subnet address                                                      |                     |
| `parameters`           | Array, Hash   | `nil`                            | DHCPD parameters for the subnet                                     |                     |
| `options`              | Array, Hash   | `nil`                            | DHCPD options for the subnet                                        |                     |
| `evals`                | Array         | `nil`                            | DHCPD conditional statements for the subnet (see dhcp-eval(5))      |                     |
| `keys`                 | Hash          | `nil`                            | TSIG keys configuration                                             |                     |
| `zones`                | Hash          | `nil`                            | Dynamic DNS zone configuration                                      |                     |
| `allow`                | Array         | `nil`                            |                                                                     |                     |
| `deny`                 | Array         | `nil`                            |                                                                     |                     |
| `extra_lines`          | String, Array | `nil`                            | Extra lines to append to the configuration file                     |                     |
| `pool`                 | Hash          | `nil`                            | Pool configuration hash, accepts most properties (see dhcpd.conf(5))|                     |

## Examples

```ruby
dhcp_subnet '192.168.9.0' do
  comment 'Listen Subnet Declaration'
  subnet '192.168.9.0'
  netmask '255.255.255.0'
end

dhcp_subnet 'basic' do
  comment 'Basic Subnet Declaration'
  subnet '192.168.0.0'
  netmask '255.255.255.0'
  options [
    'routers 192.168.0.1'
    'time-offset 10',
  ]
  pool 'range' => '192.168.0.100 192.168.0.200'
end
```

```ruby
dhcp_subnet 'dhcpv6_listen' do
  ip_version :ipv6
  comment 'Testing DHCPv6 Basic Subnet'
  subnet '2001:db8:1::'
  prefix 64
end

dhcp_subnet 'dhcpv6_basic' do
  ip_version :ipv6
  comment 'Testing DHCPv6 Basic Subnet'
  subnet '2001:db8:2:1::'
  prefix 64
  options(
    'domain-name' => '"test.domain.local"',
    'dhcp6.name-servers' => '2001:4860:4860::8888, 2001:4860:4860::8844'
  )
  parameters(
    'ddns-domainname' => '"test.domain.local"',
    'default-lease-time' => 28800
  )
  range [
    '2001:db8:2:1::1:0/112',
  ]
end
```
