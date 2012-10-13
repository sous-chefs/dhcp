default[:dhcp][:interfaces] = []
default[:dhcp][:failover] = nil
default[:dhcp][:allows] = [ "booting", "bootp" ]

default[:dhcp][:parameters] = {
  "default-lease-time" => "6400",
  "ddns-domainname" => "\"#{domain}\"",
  "ddns-update-style" => "interim",
  "max-lease-time" => "60480"
}

default[:dhcp][:options] = { 
  "domain-name" => "\"#{domain}\""
}

default[:dhcp][:dir] = "/etc/dhcp"
case node[:platform_family]
when "rhel"
  default[:dhcp][:package_name] = "dhcp"
  default[:dhcp][:service_name] = "dhcpd"

  if node['platform_version'].to_i >= 6
    default[:dhcp][:config_file]  = "/etc/dhcpd/dhcpd.conf" 
  else 
    default[:dhcp][:config_file]  = "/etc/dhcpd.conf"
  end

  default[:dhcp][:init_config]  = "/etc/sysconfig/dhcpd"
when "debian"
  default[:dhcp][:package_name] = "isc-dhcp-server"
  default[:dhcp][:service_name] = "isc-dhcp-server"
  default[:dhcp][:config_file]  = "/etc/dhcp/dhcpd.conf"
  default[:dhcp][:init_config]  = "/etc/default/isc-dhcp-server"
end
