# dhcp_service

[Back to resource list](../README.md#resources)

Manage the DHCPD and DHCPD6 services.

Introduced: v7.0.0

## Actions

- `:create`
- `:delete`
- `:start`
- `:stop`
- `:reload`
- `:restart`
- `:enable`
- `:disable`

## Properties

| Name                      | Type          | Default                       | Description                                                            | Allowed Values      |
| ------------------------- | ------------- | ----------------------------- | ---------------------------------------------------------------------- | ------------------- |
| `ip_version`              | Symbol        | `:ipv4`                       | Select DHCP or DHCPv6 server to configure                              | `:ipv4`, `:ipv6`    |
| `service_name`            | String        | `nil`                         | Custom service name                                                    |                     |
| `systemd_unit_content`    | String, Hash  | Platform dependant            | systemd unit file content for service                                  |                     |
| `config_file`             | String        | `/etc/dhcp/dhcpd(6).conf`     | The full path to the DHCP server configuration on disk                 |                     |
| `config_test`             | True, False   | `true`                        | Perform configuration test before starting, restarting or reload       |                     |
| `config_test_fail_action` | Symbol        | `:raise`                      | Action to perform upon a configuration test failure                    | `:raise`, `:log`    |

## Examples

```ruby
dhcp_service 'dhcpd' do
  ip_version :ipv4
  action [:create, :enable, :start]
end
```

## Validation and cleanup

Service actions are delayed until the end of convergence, after configuration and
include files are available. Start, restart and reload validate the selected
configuration first. An absent configuration prevents those actions.
`config_test false` skips the syntax test; `config_test_fail_action :log` logs a
failure and skips the action, while `:raise` fails convergence.

Names may include the `.service` suffix. `:delete` stops and disables the native
service before deleting its systemd unit. It does not delete leases or packages.

```ruby
dhcp_service 'dhcpd6' do
  ip_version :ipv6
  action [:create, :enable, :start]
end
```
