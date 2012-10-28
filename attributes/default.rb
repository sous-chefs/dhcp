
default[:dhcp][:failover] = nil
default[:dhcp][:allows] = [ "booting", "bootp", "unknown-clients" ]

default[:dhcp][:hosts] = []
default[:dhcp][:groups] = []
default[:dhcp][:networks] = []
default[:dhcp][:interfaces] = []
default[:dhcp][:hosts_bag] = "dhcp_hosts"
default[:dhcp][:networks_bag] = "dhcp_networks"
default[:dhcp][:groups_bag] = "dhcp_groups"


default[:dhcp][:parameters] = {
  "default-lease-time" => "6400",
  "ddns-domainname" => "\"#{domain}\"",
  "ddns-update-style" => "interim",
  "max-lease-time" => "86400",
  "update-static-leases" => "true",
  "one-lease-per-client" =>  "true",
  "authoritative" => "",
  "ping-check" => "true",
  # use localhost (since its a dhcp server)
  "next-server" => "#{ipaddress}",
  "filename" => '"pxelinux.0"'
}

default[:dhcp][:options] = { 
  "domain-name" => "\"#{domain}\"",
  "domain-name-servers" => "8.8.8.8"
}

default[:dhcp][:dir] = "/etc/dhcp"

case node[:platform_family]
when "rhel"
  default[:dhcp][:package_name] = "dhcp"
  default[:dhcp][:service_name] = "dhcpd"

  if node['platform_version'].to_i >= 6
    default[:dhcp][:config_file]  = "/etc/dhcp/dhcpd.conf" 
  else 
    default[:dhcp][:dir] = "/etc/dhcpd"
    default[:dhcp][:config_file]  = "/etc/dhcpd.conf"
  end

  default[:dhcp][:init_config]  = "/etc/sysconfig/dhcpd"
when "debian"
  default[:dhcp][:package_name] = "isc-dhcp-server"
  default[:dhcp][:service_name] = "isc-dhcp-server"
  default[:dhcp][:config_file]  = "/etc/dhcp/dhcpd.conf"
  default[:dhcp][:init_config]  = "/etc/default/isc-dhcp-server"
end
