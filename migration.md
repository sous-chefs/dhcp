# DHCP resource completion

This release keeps the eight existing `dhcp_*` resource names and the ISC DHCP
configuration format. It requires Chef 16.0 or later for native resource partials.
Deploy it through a replacement major release,
not the previously generated 8.1.20 patch release.

## Supported platforms

On Amazon Linux 2023, enable the optional vendor SPAL repository before
`dhcp_package`, for example with `package 'spal-release'`. AWS supplies
`dhcp-server` through SPAL on release 2023.9.20251117 and later. The resource
does not enable repositories automatically. See
[AWS's SPAL setup and support contract](https://docs.aws.amazon.com/linux/al2023/ug/configure-spal-repository.html).

The acceptance matrix uses maintained releases in the Debian, Ubuntu, Fedora,
Amazon Linux and RHEL families. It includes Debian 12, Ubuntu 22.04/24.04, Amazon
Linux 2023, Fedora, CentOS Stream 9, and AlmaLinux/Oracle Linux/Rocky Linux 8/9.
Obsolete CentOS 7, CentOS Stream 8, Debian 9/10/11 and Ubuntu 18.04/20.04 test
releases are removed from CI. Runtime metadata and the existing non-systemd
service fallback remain declared; those obsolete combinations are not acceptance
claims. Scientific Linux has no maintained release, so CI uses maintained RHEL
derivatives for that family. This does not convert ISC DHCP to Kea.

## Resource behaviour

Keep package, configuration, fragment and service declarations. Service unit names
now accept an existing `.service` suffix without doubling it. Configuration tests
still precede start/restart/reload, but running the test alone no longer reports
a resource update. `config_test` and `config_test_fail_action` retain their roles.

Use `dhcp_package`, rather than the obsolete `dhcp_install` name formerly shown
in the README. Use the `pools` property for subnet pools.

For `dhcp_group :delete` and `dhcp_shared_network :delete`, pass the same nested
host/subnet keys used when creating the resource. This removes generated children
as well as the parent fragment. Other fragments and shared directories remain.

Removing a service stops/disables it before deleting its unit. Package removal
is explicit through `dhcp_package :remove`. Leases, shared environment files and
caller-managed include files are retained. Do not replace these actions with
recursive deletion of `/etc/dhcp` or the lease directory.

## Testing

Policyfile replaces Berkshelf. Resolve dependencies with `chef install Policyfile.rb`.
Run `chef exec rspec`, `cookstyle --cache false` and the default Kitchen suite.
The default suite converges twice and enforces zero changes on the second run.
The `delete` suite is an explicit create-then-partial-delete transition, so it runs
once. The separate removal journey creates an instance, then applies removal twice
and checks that lease data remains.
