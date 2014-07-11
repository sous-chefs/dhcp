@test "test the subnet config file exists" {
  FILE=/etc/dhcp/subnets.d/192.168.34.0.conf
  [ -e "$FILE" ]
}

@test "multiple ranges found in subnet pool" {
  cat /etc/dhcp/subnets.d/192.168.34.0.conf | {
    run grep -c range
    [ "$status" -eq 0 ]
    [ "$output" == "3" ]
  }
}
