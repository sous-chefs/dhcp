# encoding: UTF-8
#
# Setup subnets
#

include_recipe 'dhcp::_service'

node['dhcp']['networks'].each do |net|
  if node['dhcp']['use_bags'] == true
    data = data_bag_item(node['dhcp']['networks_bag'], Dhcp::Helpers.escape(net))
  else
    data = node['dhcp']['network_data'].fetch net, nil
  end

  next unless data
  # run the lwrp with the bag data
  dhcp_subnet data['address'] do
    broadcast data['broadcast'] if data.key? 'broadcast'
    netmask data['netmask'] if data.key? 'netmask'
    routers data['routers'] || []
    options data['options'] || []
    if data.key?('range') || node['dhcp']['failover']
      pool do
        range data['range'] if data.key? 'range'
        peer node['domain'] if node['dhcp']['failover']
        allow data['allow'] if data.key? 'allow'
      end
    end
    ddns data['ddns'] if data.key? 'ddns'
    conf_dir node['dhcp']['dir']
    evals data['evals'] || []
    key data['key'] || {}
    zones data['zones'] || []
    next_server data['next_server'] if data.key? 'next_server'
  end
end

# Load databag data
if node['dhcp']['use_bags']
  node['dhcp']['shared_networks'].each do |shared_net|
    network_data = data_bag_item(node['dhcp']['networks_bag'], Dhcp::Helpers.escape(shared_net))
    dhcp_shared_network shared_net do
      network_data['subnets'].each do |_net, data|
        subnet data['address'] do
          broadcast data['broadcast'] if data.key? 'broadcast'
          netmask data['netmask'] if data.key? 'netmask'
          routers data['routers'] || []
          options data['options'] || []
          if data.key?('range') || node['dhcp']['failover']
            pool do
              range data['range'] if data.key? 'range'
              peer node['domain'] if node['dhcp']['failover']
              allow data['allow'] if data.key? 'allow'
            end
          end
          ddns data['ddns'] if data.key? 'ddns'
          conf_dir node['dhcp']['dir']
          evals data['evals'] || []
          key data['key'] || {}
          zones data['zones'] || []
          next_server data['next_server'] if data.key? 'next_server'
        end
      end
    end
  end
end

# Load node attribute data
unless node['dhcp']['use_bags']
  node['dhcp']['shared_network_data'].each do |shared_net, network_data|
    dhcp_shared_network shared_net do
      network_data['subnets'].each do |_net, data|
        subnet data['address'] do
          broadcast data['broadcast'] if data.key? 'broadcast'
          netmask data['netmask'] if data.key? 'netmask'
          routers data['routers'] || []
          options data['options'] || []
          if data.key?('range') || node['dhcp']['failover']
            pool do
              range data['range'] if data.key? 'range'
              peer node['domain'] if node['dhcp']['failover']
              allow data['allow'] if data.key? 'allow'
            end
          end
          ddns data['ddns'] if data.key? 'ddns'
          conf_dir node['dhcp']['dir']
          evals data['evals'] || []
          key data['key'] || {}
          zones data['zones'] || []
          next_server data['next_server'] if data.key? 'next_server'
        end
      end
    end
  end
end
