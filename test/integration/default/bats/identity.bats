# vim: ft=sh:

@test "identity-api registered with etcd" {
  curl http://127.0.0.1:4001/v1/keys/services/identity-api/members
}

@test "identity-admin registered with etcd" {
  curl http://127.0.0.1:4001/v1/keys/services/identity-admin/members
}

@test "identity api is running" {
  netstat -tan | grep 5000
}

@test "identity admin is running" {
  netstat -tan | grep 35357
}
