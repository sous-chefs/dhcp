execute 'add dummy interface eth1' do
  command 'ip link add dev eth1 type dummy'
  not_if 'ip a show dev eth1'
end

execute 'online eth1' do
  command 'ip link set dev eth1 up'
  not_if 'ip a show dev eth1 | grep UP'
end

execute 'address eth1' do
  command 'ip addr add 192.168.9.1 dev eth1'
  not_if 'ip a show dev eth1 | grep \'inet 192.168.9.1\''
end

execute 'remove ipv6 default route' do
  command 'ip -6 route del ::/0'
  only_if 'ip -6 route | grep default'
end
