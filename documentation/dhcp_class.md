# dhcp_class

[Back to resource list](../README.md#resources)

Create a DHCPD class configuration. (<https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcpdconf#client-classing>)

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
| `match`                | String        | `nil`                            | DHCPD match statement                                               |                     |
| `options`              | Array, Hash   | `nil`                            | DHCPD options for the class                                         |                     |
| `parameters`           | Array, Hash   | `nil`                            | DHCPD parameters for the class                                      |                     |
| `subclass`             | Array         | `nil`                            | Subclasses to include within the class                              |                     |

## Examples

```ruby
dhcp_class 'BlankClass' do
  match 'hardware'
end
```

```ruby
dhcp_class 'RegisteredHosts' do
  match 'hardware'
  subclass [
    '1:10:bf:48:42:55:01',
    '1:10:bf:48:42:55:02',
  ]
end
```

```ruby
dhcp_class 'SpecialHosts' do
  match 'hardware'
  subclass [
    '1:10:bf:48:42:56:01',
    '1:10:bf:48:42:56:02',
  ]
  option(
    'special-option' => 'value'
  )
end
```
