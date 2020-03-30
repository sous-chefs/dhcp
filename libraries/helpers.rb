module Dhcp
  module Cookbook
    module Helpers
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
          '/etc/dhcp/dhcpd.conf'
        when :ipv6
          '/etc/dhcp/dhcpd6.conf'
        else
          raise "#{ip_version} is unknown."
        end
      end

      def dhcpd_failover_config_file(ip_version)
        case ip_version
        when :ipv4
          '/etc/dhcp/dhcpd.failover.conf'
        when :ipv6
          raise 'DHCPD failover is not supported for IPv6'
        else
          raise "#{ip_version} is unknown."
        end
      end

      def dhcpd_config_includes_directory(ip_version)
        case ip_version
        when :ipv4
          "#{dhcp_config_dir}/dhcpd.conf.d"
        when :ipv6
          "#{dhcp_config_dir}/dhcpd6.conf.d"
        else
          raise "#{ip_version} is unknown."
        end
      end

      def dhcpd_lease_file(ip_version)
        var_dir = if platform_family?('debian')
                    '/var/lib/dhcp'
                  else
                    '/var/lib/dhcpd'
                  end

        case ip_version
        when :ipv4
          "#{var_dir}/dhcpd.leases"
        when :ipv6
          "#{var_dir}/dhcpd6.leases"
        else
          raise "#{ip_version} is unknown."
        end
      end
    end
  end
end
