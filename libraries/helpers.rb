module Dhcp
  module Cookbook
    module Helpers
      def property_array(property)
        return property if property.is_a?(Array)

        [property]
      end

      def dhcpd_user
        'root'
      end

      def dhcpd_group
        return 'root' if node['platform'].eql?('debian')

        'dhcpd'
      end

      def dhcpd_packages
        case node['platform_family']
        when 'rhel'
          return %w(dhcp) if node['platform_version'].to_i < 8

          %w(dhcp-server)
        when 'fedora'
          %w(dhcp-server)
        when 'debian'
          %w(isc-dhcp-server isc-dhcp-server-ldap)
        end
      end

      def dhcpd_service_name(ip_version)
        {
          'rhel' => {
            ipv4: 'dhcpd',
            ipv6: 'dhcpd6',
          },
          'fedora' => {
            ipv4: 'dhcpd',
            ipv6: 'dhcpd6',
          },
          'debian' => {
            ipv4: 'isc-dhcp-server',
            ipv6: 'isc-dhcp-server6',
          },
        }.fetch(node['platform_family']).fetch(ip_version)
      end

      def dhcpd_config_dir
        '/etc/dhcp'
      end

      def dhcpd_config_file(ip_version)
        case ip_version
        when :ipv4
          "#{dhcpd_config_dir}/dhcpd.conf"
        when :ipv6
          "#{dhcpd_config_dir}/dhcpd6.conf"
        else
          raise "IP version #{ip_version} is unknown."
        end
      end

      def dhcpd_failover_config_file(ip_version)
        return '/etc/dhcp/dhcpd.failover.conf' if ip_version.eql?(:ipv4)

        nil
      end

      def dhcpd_config_includes_directory(ip_version)
        case ip_version
        when :ipv4
          "#{dhcpd_config_dir}/dhcpd.conf.d"
        when :ipv6
          "#{dhcpd_config_dir}/dhcpd6.conf.d"
        else
          raise "IP version #{ip_version} is unknown."
        end
      end

      def dhcpd_config_resource_directory(ip_version, resource_type)
        case resource_type
        when :dhcp_class
          "#{dhcpd_config_includes_directory(ip_version)}/classes.d"
        when :dhcp_group
          "#{dhcpd_config_includes_directory(ip_version)}/groups.d"
        when :dhcp_host
          "#{dhcpd_config_includes_directory(ip_version)}/hosts.d"
        when :dhcp_shared_network
          "#{dhcpd_config_includes_directory(ip_version)}/shared_networks.d"
        when :dhcp_subnet
          "#{dhcpd_config_includes_directory(ip_version)}/subnets.d"
        else
          raise "Invalid resource type #{resource_type}."
        end
      end

      def dhcpd_config_includes_directories
        %w(groups.d hosts.d subnets.d shared_networks.d classes.d)
      end

      def dhcpd_lib_dir
        if platform_family?('debian')
          '/var/lib/dhcp'
        else
          '/var/lib/dhcpd'
        end
      end

      def dhcpd_lib_dir_options
        case node['platform']
        when 'amazon', 'centos', 'fedora', 'rhel'
          {
            'owner' => 'dhcpd',
            'group' => 'dhcpd',
            'mode' => '0755',
          }
        when 'ubuntu'
          {
            'owner' => 'root',
            'group' => 'dhcpd',
            'mode' => '0775',
          }
        when 'debian'
          {
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0755',
          }
        end
      end

      def dhcpd_lease_file(ip_version)
        case ip_version
        when :ipv4
          "#{dhcpd_lib_dir}/dhcpd.leases"
        when :ipv6
          "#{dhcpd_lib_dir}/dhcpd6.leases"
        else
          raise "#{ip_version} is unknown."
        end
      end

      def dhcpd_lease_file_options
        case node['platform_family']
        when 'amazon', 'centos', 'fedora', 'rhel'
          {
            'owner' => 'dhcpd',
            'group' => 'dhcpd',
            'mode' => '0644',
            'action' => :create_if_missing,
          }
        when 'ubuntu'
          {
            'owner' => 'root',
            'group' => 'dhcpd',
            'mode' => '0664',
            'action' => :create_if_missing,
          }
        when 'debian'
          {
            'owner' => 'root',
            'group' => 'root',
            'mode' => '0644',
            'action' => :create_if_missing,
          }
        end
      end

      def dhcpd_use_systemd?
        if (platform_family?('rhel') && node['platform_version'].to_i < 7) ||
           (platform?('ubuntu') && node['platform_version'].to_i < 14) ||
           (platform_family?('amazon') && node['platform_version'].to_i < 2)
          false
        else
          true
        end
      end

      def dhcpd_systemd_unit_content(ip_version)
        raise 'Invalid ip_version' unless ip_version.is_a?(Symbol) && %i(ipv4 ipv6).include?(ip_version)
        dhcp6 = ip_version.eql?(:ipv6)

        case node['platform']
        when 'amazon', 'centos', 'fedora', 'rhel'
          {
            'Unit' => {
              'Description' => "DHCP#{dhcp6 ? 'v6' : 'v4'} Server Daemon",
              'Documentation' => 'man:dhcpd(8) man:dhcpd.conf(5)',
              'Wants' => 'network-online.target',
              'After' => [
                'network-online.target',
                'time-sync.target',
              ],
              'ConditionPathExists' => [
                '/etc/sysconfig/dhcpd',
                "|/etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf",
              ],
            },
            'Service' => {
              'Type' => 'notify',
              'EnvironmentFile' => '-/etc/sysconfig/dhcpd',
              'ExecStart' => "/usr/sbin/dhcpd -f #{dhcp6 ? '-6' : '-4'} -cf /etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf -user dhcpd -group dhcpd --no-pid $DHCPDARGS",
              'StandardError' => 'null',
            },
            'Install' => {
              'WantedBy' => 'multi-user.target',
            },
          }
        when 'debian'
          {
            'Unit' => {
              'Description' => "ISC DHCP IP#{dhcp6 ? 'v6' : 'v4'} Server",
              'Documentation' => 'man:dhcpd(8) man:dhcpd.conf(5)',
              'Wants' => 'network-online.target',
              'After' => [
                'network-online.target',
                'time-sync.target',
              ],
              'ConditionPathExists' => [
                '/etc/default/isc-dhcp-server',
                "|/etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf",
              ],
            },
            'Service' => {
              'EnvironmentFile' => '/etc/default/isc-dhcp-server',
              'RuntimeDirectory' => 'dhcp-server',
              'ExecStart' => "/usr/sbin/dhcpd -f #{dhcp6 ? '-6' : '-4'} -cf /etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf -pf /run/dhcp-server/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.pid $INTERFACES",
            },
            'Install' => {
              'WantedBy' => 'multi-user.target',
            },
          }
        when 'ubuntu'
          {
            'Unit' => {
              'Description' => "ISC DHCP IP#{dhcp6 ? 'v6' : 'v4'} Server",
              'Documentation' => 'man:dhcpd(8) man:dhcpd.conf(5)',
              'Wants' => 'network-online.target',
              'After' => [
                'network-online.target',
                'time-sync.target',
              ],
              'ConditionPathExists' => [
                '/etc/default/isc-dhcp-server',
                "|/etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf",
              ],
            },
            'Service' => {
              'EnvironmentFile' => '/etc/default/isc-dhcp-server',
              'RuntimeDirectory' => 'dhcp-server',
              'ExecStart' => "/usr/sbin/dhcpd -f #{dhcp6 ? '-6' : '-4'} -cf /etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf -user dhcpd -group dhcpd -pf /run/dhcp-server/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.pid $INTERFACES",
            },
            'Install' => {
              'WantedBy' => 'multi-user.target',
            },
          }
        else
          raise "Platform #{node['platform']} is not a supported systemd OS."
        end
      end
    end
  end
end
