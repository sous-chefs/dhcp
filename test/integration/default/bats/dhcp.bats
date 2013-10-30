# vim: ft=sh:

@test "dhcp server is running" {
  ps aux | grep -q [d]hcpd
}
