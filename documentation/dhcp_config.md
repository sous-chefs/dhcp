# dhcp_config

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
| `config_failover_file` | String        | `/etc/dhcp/dhcpd.failover.conf`  | DHCP failover configuration file path                               |                     |
| `config_includes_directory` | String   | `/etc/dhcp/dhcpd(6).d`           | Directory to create included configuration files in                 |                     |
| `lib_dir`              | String        | Platform dependant               | DHCPD lib directory path                                            |                     |
| `lease_file`           | String        | Platform dependant               | DHCPD lease file path                                               |                     |
| `allow`                | Array         | `nil`                            |                                                                     |                     |
| `deny`                 | Array         | `nil`                            |                                                                     |                     |
| `ignore`               | Array         | `nil`                            |                                                                     |                     |
| `parameters`           | Array, Hash   | `nil`                            | DHCPD global parameters                                             |                     |
| `options`              | Array, Hash   | `nil`                            | DHCPD global options                                                |                     |
| `evals`                | Array         | `nil`                            | DHCPD conditional statements (see dhcp-eval(5))                     |                     |
| `keys`                 | Hash          | `nil`                            | TSIG keys configuration                                             |                     |
| `zones`                | Hash          | `nil`                            | Dynamic DNS zone configuration                                      |                     |
| `hooks`                | Hash          | `nil`                            | Server event action configuration                                   |                     |
| `failover`             | Hash          | `nil`                            | DHCP failover configuration                                         |                     |
| `include_files`        | Array         | `nil`                            | Additional configuration files to include                           |                     |
| `extra_lines`          | String, Array | `nil`                            | Extra lines to append to the configuration file                     |                     |

## Examples

```ruby
dhcp_config '/etc/dhcp/dhcpd.conf' do
  allow %w(booting bootp unknown-clients)
  parameters(
    'default-lease-time' => 7200,
    'ddns-update-style' => 'interim',
    'max-lease-time' => 86400,
    'update-static-leases' => true,
    'one-lease-per-client' => true,
    'authoritative' => '',
    'ping-check' => true
  )
  options(
    'domain-name' => '"test.domain.local"',
    'domain-name-servers' => '8.8.8.8',
    'host-name' => ' = binary-to-ascii (16, 8, "-", substring (hardware, 1, 6))'
  )
  hooks(
    'commit' => ['use-host-decl-names on'],
    'release' => ['use-host-decl-names on']
  )
  include_files [
    '/etc/dhcp/extra1.conf',
    '/etc/dhcp/extra2.conf',
    '/etc/dhcp_override/list.conf',
  ]
  action :create
end
```

```ruby
dhcp_config '/etc/dhcp/dhcpd6.conf' do
  ip_version :ipv6
  deny %w(duplicates)
  parameters(
    'default-lease-time' => 7200,
    'ddns-updates' => 'on',
    'ddns-update-style' => 'interim',
    'max-lease-time' => 86400,
    'update-static-leases' => true,
    'one-lease-per-client' => 'on',
    'authoritative' => '',
    'ping-check' => true
  )
  options(
    'dhcp6.name-servers' => '2001:4860:4860::8888, 2001:4860:4860::8844'
  )
  action :create
end
```
