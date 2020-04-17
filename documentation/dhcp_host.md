# dhcp_host

[Back to resource list](../README.md#resources)

Create a DHCPD host configuration. (<https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcpdconf#reference-declarations> - *The **host** statement*)

Introduced: v7.0.0

## Actions

- `:create`
- `:delete`

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `comment`              | String        | `nil`                            | Comment to add to the configuration file                            |                     |
| `ip_version`           | Symbol        | `:ipv4`                          | Select DHCP or DHCPv6 server to configure                           | `:ipv4`, `:ipv6`    |
| `conf_dir`             | String        | `/etc/dhcp/dhcpd(6).d/hosts.d`   | Directory to create configuration file in                           |                     |
| `cookbook`             | String        | `/etc/dhcp/dhcpd(6).d/hosts.d`   | Cookbook to source configuration file template from                 |                     |
| `template`             | String        | `/etc/dhcp/dhcpd(6).d/hosts.d`   | Template to use to generate the configuration file                  |                     |
| `owner`                | String        | Platform dependant               | Owner of the generated configuration file                           |                     |
| `group`                | String        | Platform dependant               | Group of the generated configuration file                           |                     |
| `mode`                 | String        | `'0640'`                         | Filemode of the generated configuration file                        |                     |
| `identifier`           | String        | `nil`                            | DHCPD host identifier (MAC or DHCID)                                |                     |
| `address`              | String        | `nil`                            | DHCPD address to issue                                              |                     |
| `parameters`           | Array, Hash   | `nil`                            | DHCPD parameters for the host                                       |                     |
| `options`              | Array, Hash   | `nil`                            | DHCPD options for the host                                          |                     |

## Examples

```ruby
dhcp_host 'IPv4-Host' do
  identifier 'hardware ethernet 00:53:00:00:00:01'
  address '192.168.0.10'
  options(
    'host-name' => 'test-ipv4-host'
  )
end
```

```ruby
dhcp_host 'IPv6-Host' do
  ip_version :ipv6
  identifier 'host-identifier option dhcp6.client-id 00:53:00:00:00:01:a4:65:b7:c8'
  address '2001:db8:1:1:0:0:1:10'
  options(
      'host-name' => 'test-ipv6-host'
    )
end
```
