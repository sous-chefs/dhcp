apt_update 'update'

package node['dhcp']['package_name']
directory node['dhcp']['dir']
