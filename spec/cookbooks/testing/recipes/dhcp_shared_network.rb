dhcp_shared_network 'single' do
  subnet '192.168.1.0' do
    broadcast '192.168.1.255'
    netmask '255.255.255.0'
    routers ['192.168.1.1']
    pool do
      range '192.168.1.20 192.168.1.30'
    end
  end
end

dhcp_shared_network 'multiple' do
  subnet '192.168.2.0' do
    broadcast '192.168.2.255'
    netmask '255.255.255.0'
    routers ['192.168.2.1']
    pool do
      range ['192.168.2.20 192.168.2.30']
    end
  end
  subnet '192.168.3.0' do
    broadcast '192.168.3.255'
    netmask '255.255.255.0'
    routers ['192.168.3.1']
    pool do
      range ['192.168.3.20 192.168.3.30', '192.168.3.40 192.168.3.50']
    end
  end
end
