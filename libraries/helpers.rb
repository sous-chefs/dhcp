module Dhcp
  module Cookbook
    module Helpers
      def property_array(property)
        return property if property.is_a?(Array)

        [property]
      end

      def dhcp_packages
        case node['platform_family']
        when 'rhel'
          if platform_version.to_i < 8
            %w(dhcp)
          else
            %w(dhcp-server)
          end
        when 'fedora'
          %w(dhcp-server)
        when 'debian'
          %w(isc-dhcp-server)
        end
      end

      def dhcp_service_name
        case node['platform_family']
        when 'rhel', 'fedora'
          'dhcpd'
        when 'debian'
          'isc-dhcp-server'
        end
      end

      def dhcp_config_dir
        '/etc/dhcp'
      end

      def dhcpd_config_file(ip_version)
        case ip_version
        when :ipv4
          "#{dhcp_config_dir}/dhcpd.conf"
        when :ipv6
          "#{dhcp_config_dir}/dhcpd6.conf"
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
          "#{dhcp_config_dir}/dhcpd.conf.d"
        when :ipv6
          "#{dhcp_config_dir}/dhcpd6.conf.d"
        else
          raise "IP version #{ip_version} is unknown."
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
        case node['platform_family']
        when 'rhel', 'fedora'
          {
            'owner' => 'dhcpd',
            'group' => 'dhcpd',
            'mode' => '0755',
          }
        when 'debian'
          {
            'owner' => 'root',
            'group' => 'dhcpd',
            'mode' => '0775',
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
        when 'rhel', 'fedora'
          {
            'owner' => 'dhcpd',
            'group' => 'dhcpd',
            'mode' => '0644',
            'action' => :create_if_missing,
          }
        when 'debian'
          {
            'owner' => 'root',
            'group' => 'dhcpd',
            'mode' => '0664',
            'action' => :create_if_missing,
          }
        end
      end

      def dhcpd_use_systemd?
        if (platform_family?('rhel') && platform_version.to_i < 7) ||
           (platform?('ubuntu') && platform_version.to_i < 14) ||
           (platform_family?('amazon') && platform_version.to_i < 2)
          false
        else
          true
        end
      end

      def dhcpd_systemd_unit_content(ip_version)
        raise 'Invalid ip_version' unless ip_version.is_a?(Symbol) && %i(ipv4 ipv6).include?(ip_version)
        dhcp6 = ip_version.eql?(:ipv6)

        case node['platform_family']
        when 'rhel', 'fedora'
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
              'ExecStart' => "/usr/sbin/dhcpd -f -cf /etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf -user dhcpd -group dhcpd --no-pid $DHCPDARGS",
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
              'ExecStart' => "/usr/sbin/dhcpd -f -cf /etc/dhcp/#{dhcp6 ? 'dhcpd6' : 'dhcpd'}.conf -user dhcpd -group dhcpd -pf /run/dhcp-server/dhcpd.pid $INTERFACES",
            },
            'Install' => {
              'WantedBy' => 'multi-user.target',
            },
          }
        else
          raise "#{node['platform_family']} is not a supported systemd OS."
        end
      end
    end
  end
end
