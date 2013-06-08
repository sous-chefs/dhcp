#
# Setup Groups
#
unless node[:dhcp][:groups].empty?
  node[:dhcp][:groups].each do  |group|
    group_data = data_bag_item( node[:dhcp][:groups_bag], group)

    next unless group_data
    dhcp_group group do
      parameters  group_data["parameters"]  || []
      hosts       group_data["hosts"] || []
      conf_dir  node[:dhcp][:dir]
    end
  end
end

