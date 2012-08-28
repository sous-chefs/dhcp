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

case node[:platform]
when "centos", "redhat", "suse", "fedora", "xenserver", "amazon"
  default[:dhcp][:package_name] = "dhcp"
  default[:dhcp][:service_name] = "dhcpd"

  if node['platform_version'].to_i >= 6
    default[:dhcp][:config_file]  = "/etc/dhcpd/dhcpd.conf" 
  else 
    default[:dhcp][:config_file]  = "/etc/dhcpd.conf"
  end

  default[:dhcp][:init_config]  = "/etc/sysconfig/dhcpd"
when "debian", "ubuntu"
  default[:dhcp][:package_name] = "dhcp3-server"
  default[:dhcp][:service_name] = "dhcp3-server"
  default[:dhcp][:config_file]  = "/etc/dhcp3/dhcpd.conf"
  default[:dhcp][:init_config]  = "/etc/default/dhcp3-server"
end
