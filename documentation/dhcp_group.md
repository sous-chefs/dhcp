# dhcp_group

[Back to resource list](../README.md#resources)

Create a DHCPD group configuration. (<https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcpdconf#reference-declarations> - *The **group** statement*)

Introduced: v7.0.0

## Actions

- `:create`
- `:delete`

## Properties

| Name                   | Type          | Default                          | Description                                                         | Allowed Values      |
| ---------------------- | ------------- | -------------------------------- | ------------------------------------------------------------------- | ------------------- |
| `comment`              | String        | `nil`                            | Comment to add to the configuration file                            |                     |
| `ip_version`           | Symbol        | `:ipv4`                          | Select DHCP or DHCPv6 server to configure                           | `:ipv4`, `:ipv6`    |
| `conf_dir`             | String        | `/etc/dhcp/dhcpd(6).d/groups.d`  | Directory to create configuration file in                           |                     |
| `cookbook`             | String        | `/etc/dhcp/dhcpd(6).d/groups.d`  | Cookbook to source configuration file template from                 |                     |
| `template`             | String        | `/etc/dhcp/dhcpd(6).d/groups.d`  | Template to use to generate the configuration file                  |                     |
| `owner`                | String        | Platform dependant               | Owner of the generated configuration file                           |                     |
| `group`                | String        | Platform dependant               | Group of the generated configuration file                           |                     |
| `mode`                 | String        | `'0640'`                         | Filemode of the generated configuration file                        |                     |
| `parameters`           | Array, Hash   | `nil`                            | DHCPD parameters for the group                                      |                     |
| `options`              | Array, Hash   | `nil`                            | DHCPD options for the group                                         |                     |
| `evals`                | Array         | `nil`                            | DHCPD conditional statements for the group (see dhcp-eval(5))       |                     |
| `hosts`                | Hash          | `nil`                            | Hosts configuration to include within the group                     |                     |

## Examples

```ruby
dhcp_group 'IPPgones' do
  options(
    'tftp-server-name' => '192.0.2.10'
  )
end
```
