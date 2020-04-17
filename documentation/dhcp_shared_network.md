# dhcp_shared_network

[Back to resource list](../README.md#resources)

Create a DHCPD shared network configuration. (<https://kb.isc.org/docs/isc-dhcp-44-manual-pages-dhcpdconf#reference-declarations> - *The **shared-network** statement*)

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
| `subnets`              | Hash          | `nil`                            | Subnets for the DHCPD shared network                                |                     |

## Examples

```ruby
dhcp_shared_network 'single' do
  subnets(
    '192.168.1.0' => {
      'subnet' => '192.168.1.0',
      'netmask' => '255.255.255.0',
      'options' => {
        'broadcast-address' => '192.168.1.255',
        'routers' => '192.168.1.1',
      },
      'pool' => {
        'range' => '192.168.1.20 192.168.1.30',
      },
    }
  )
end
```

```ruby
dhcp_shared_network 'multiple' do
  subnets(
    '192.168.2.0' => {
      'subnet' => '192.168.2.0',
      'netmask' => '255.255.255.0',
      'options' => {
        'broadcast-address' => '192.168.2.255',
        'routers' => '192.168.2.1',
      },
      'pool' => {
        'range' => '192.168.2.20 192.168.2.30',
      },
    },
    '192.168.3.0' => {
      'subnet' => '192.168.3.0',
      'netmask' => '255.255.255.0',
      'options' => {
        'broadcast-address' => '192.168.3.255',
        'routers' => '192.168.3.1',
      },
      'pool' => {
        'range' => [
          '192.168.3.20 192.168.3.30',
          '192.168.3.40 192.168.3.50',
        ],
      },
    }
  )
end
```
