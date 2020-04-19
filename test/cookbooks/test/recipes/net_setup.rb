execute 'testing address eth0 - ipv4' do
  command 'ip addr add 192.168.9.1 dev eth0'
  not_if 'ip a show dev eth0 | grep \'inet 192.168.9.1\''
end

execute 'testing - enable ipv6' do
  command 'sysctl net.ipv6.conf.eth0.disable_ipv6=0'
end

execute 'testing address eth0 - ipv6' do
  command 'ip -6 addr add 2001:db8:1::1/64 dev eth0'
  not_if 'ip a show dev eth0 | grep \'inet6 2001:db8:1::1\''
end

execute 'remove ipv6 default route' do
  command 'ip -6 route del ::/0'
  only_if 'ip -6 route | grep default'
  action :nothing
end.run_action(:run)
