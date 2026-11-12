# DHCP resource completion

## Workflow startup audit

Do not rely solely on PR `statusCheckRollup` when deciding whether CI is green.
On migration head `21725cf`, it showed 32 successful checks, but omitted two
workflow `startup_failure` runs with zero check runs. The caller permission
errors were visible on the public run pages:

* Conventional commits run `43209007473`: nested job `main` requested
  `pull-requests: read`, but the caller only allowed `pull-requests: none`.
* File protection run `43209007291`: nested `prevent-metadata-change` and
  `prevent-workflow-change` requested `pull-requests: write`, but the caller
  only allowed `pull-requests: none`.

The migration was admin-merged before this omission was discovered. The narrow
follow-up grants only the permissions required by each pinned reusable caller.
Before merging any release, verify the full Actions run inventory at the exact
head as well as PR check conclusions; startup failures have no ordinary check
run and must not be counted as success or ignored.

After the permission repair, run `43212000258` demonstrated the v3 action's
event contract: `Only pull_request_target events are supported. Event was:
pull_request`. An earlier same-SHA run passed because its triggering actor
`damacus` hit the trusted-actor fast path. The failed edited-event actor was
`blacksmith-sh[bot]`; the action checks `context.actor`, not the PR author.

The file-protection caller therefore uses `pull_request_target`, for opened,
reopened and synchronize events only. Title/body edits do not change files and
are omitted; conventional-title validation still processes edits. Audited the
two-step reusable workflow at `3cdff8f6f62b3db50db18f41b2de281297e355d3`
and all five source files plus the distributed entrypoint of its only action
at `440fe0989b54093ce834a504af595ee55967da4d`. They use Octokit to read changed
file names/status, compare caller-supplied constant patterns, and optionally
close the PR through the API. They do not check out PR contents, execute PR
code or send PR text to a shell or evaluator. Keep this caller API-only.

The target event uses the default-branch workflow, so the new event cannot be
accepted as tested merely because this repair PR is green. Observe a real
default-branch target run after bootstrap and before any release merge.

## Scope and product

The owner selected full custom-resource completion and a replacement major
release. Keep the eight public `dhcp_*` resources and ISC DHCP configuration
syntax. The cookbook already has no public recipes or attributes. Do not merge
the old 8.1.20 release in place of the feature migration.

ISC DHCP upstream is end of life; ISC's last releases were 4.4.3-P1 and
4.1-ESV-R16-P2 in October 2022. See <https://www.isc.org/dhcp/>. This cookbook
continues to manage distribution-provided ISC DHCP packages; it does not switch
to Kea or claim new upstream ISC security maintenance. Debian's package remains
documented at <https://packages.debian.org/bookworm/isc-dhcp-server>, and Fedora's
at <https://packages.fedoraproject.org/pkgs/dhcp/dhcp-server/>.

Amazon Linux 2023's `dhcp-server` is in the optional vendor SPAL repository,
not its default core repository. AWS lists x86_64/aarch64 packages at
<https://docs.aws.amazon.com/linux/al2023/release-notes/al-2023-spal-packages.html>.
The test fixture installs `spal-release` before DHCP, following
<https://docs.aws.amazon.com/linux/al2023/ug/configure-spal-repository.html>.
Production callers must enable their chosen package repository explicitly;
the public resource does not silently enable SPAL. SPAL requires AL2023 release
2023.9.20251117 or newer, receives upstream EPEL9 fixes and has a different
support contract from AWS core packages.

Ubuntu 24.04 uses the existing Ubuntu 22.04 test AppArmor policy, which already
grants access to the fixture's generated include files. Verify that profile
with actual Ubuntu 24.04 convergence before claiming platform acceptance.

## Package and platform contract

Debian/Ubuntu use `isc-dhcp-server` and `isc-dhcp-server-ldap`. Supported RHEL
derivatives, Fedora and Amazon Linux 2023 use `dhcp-server`. Packages are selected
through native providers and distro repositories; there is no source build or
embedded architecture-specific binary. Architecture availability follows the
chosen distro repository and is verified separately from source API tests.

Replace obsolete CI releases with maintained releases from the same supported
families. Preserve maintained RHEL 8/9 derivatives, Debian, Ubuntu, Fedora and
Amazon coverage. Do not carry unrelated macOS/Windows or openSUSE matrices into
this cookbook. Scientific Linux has no maintained successor under that name;
its runtime metadata remains declared while CI uses maintained RHEL derivatives.
Removing obsolete CI versions does not authorise dropping runtime compatibility.

## Behaviour and safe removal

IPv4 and IPv6 configuration share the distro environment file and may share
runtime state. Removing one configuration must not delete the other IP version's
environment or leases. Active leases are server data, not disposable configuration.
Never recursively remove caller configuration directories or unrelated include
files. Fragment delete actions remove their own file and update the include list.

Use native systemd resources on the existing systemd path. Preserve the native
service fallback previously selected for RHEL below 7, Ubuntu below 14 and
Amazon Linux below 2. Those obsolete versions are not in the CI matrix.
Configuration validation runs at convergence before start, restart and reload.
An already-running service must not be reported as changed merely because a
validation command ran. Preserve `config_test_fail_action`.

Resource partials require Chef 16.0: the native `use` API was checked absent in
the upstream v15.3.14 source and present in v16.0.287. The major migration records
this minimum explicitly rather than claiming compatibility with Chef 15.3.

## Acceptance

Kitchen uses privileged systemd containers on Docker's private bridge, never host
networking. DHCP test addresses/routes must change only inside the test container.
The default journey covers IPv4/IPv6 configuration, fragments and running services;
deletion must be verified after creation, with a separate repeated removal run.
Require two converges and zero resource changes on the second before claiming
idempotency. Do not mistake skipped controls or syntax-only checks for acceptance.

Use Policyfile with the local `test` cookbook. Unit tests must resolve only the
intended local cookbooks. Libraries contain shared helper modules, not legacy
resource/provider class hierarchies.
