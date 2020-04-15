dhcp_group 'ip-phones' do
  options(
    'tftp-server-name' => '"192.0.2.10"'
  )
  hosts(
    'SEP010101010101' => {
      'identifier' => 'hardware ethernet 01:01:01:01:01:01',
    }
  )
end
