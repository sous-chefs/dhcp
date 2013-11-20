#
# Hosts
#
unless node[:dhcp][:hosts].empty?



  # special key to just use all hosts in dhcp_hosts databag
  # figure which hosts to load
  host_list = node[:dhcp][:hosts]
  if host_list.is_a? String and node[:dhcp][:use_bags] == true
    if host_list.downcase == "all"
      begin
        host_list = data_bag( node[:dhcp][:hosts_bag] )
        # TODO: Make this more specific to the non existing bag
      rescue
        return
      end
    else
      search( node[:dhcp][:hosts_bag], "id:#{node[:dhcp][:hosts_bag]}" ).each do |host|
        host_lst << host['id']
      end
    end
  end

  host_list.each do  |host|
    if node[:dhcp][:use_bags] == true
      host_data = data_bag_item( node[:dhcp][:hosts_bag], Helpers::DataBags.escape_bagname( host) )
    else
      host_data = node[:dhcp][:host_data].fetch host, nil
    end

    next unless host_data
    dhcp_host host do
      hostname   host_data["hostname"]
      macaddress host_data["mac"]
      ipaddress  host_data["ip"]
      parameters host_data["parameters"] || []
      options    host_data["options"] || []
      conf_dir  node[:dhcp][:dir]
    end
  end
end

