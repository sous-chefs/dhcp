# dhcp_package

[Back to resource list](../README.md#resources)

Install ISC DHCPD server from package.

Introduced: v7.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                   | Type          | Default                       | Description                                                            | Allowed Values      |
| ---------------------- | ------------- | ----------------------------- | ---------------------------------------------------------------------- | ------------------- |
| `packages`             | String, Array | Correct packages for platform | List of packages to install for server operation                       |                     |

## Examples

```ruby
dhcp_package
```

```ruby
dhcp_package 'dhcpd' do
  packages 'isc-dhcp-server'
  end
```
