module Dhcp
  #
  # Helper methods that are used in multiple providers
  #
  module Helpers
    #
    # Determine if the resource matches this resource's type
    #
    # @param resource the resource to check
    #
    # @return [TrueClass, FalseClass] wether or not the resource matches
    #
    def resource_match?(resource)
      # Check for >= Chef 12
      return true if Gem::Version.new(Chef::VERSION) >= Gem::Version.new('12.0.0') && resource.declared_type == new_resource.declared_type

      false
    end

    #
    # List of files to include in list.conf for a collection of subconfigs (e.g. hosts, subnets, groups)
    #
    # @param [String] sub_dir - The subconfig directory for the config
    #
    # @return [Array<String>] An array of config files for the subconfig
    def includes(sub_dir)
      with_run_context :root do
        run_context.resource_collection.map do |resource|
          next unless resource_match? resource
          next unless resource.action == :add || resource.action.include?(:add)
          "#{resource.conf_dir}/#{sub_dir}/#{resource.name}.conf"
        end.compact
      end
    end

    #
    # Defined resource for list.conf to include all subconfig files
    #
    # @param [String] sub_dir - The subconfig directory for the config
    #
    def write_include(sub_dir, name)
      template "#{new_resource.conf_dir}/#{sub_dir}/list.conf #{name}" do
        path "#{new_resource.conf_dir}/#{sub_dir}/list.conf"
        cookbook 'dhcp'
        source 'list.conf.erb'
        owner 'root'
        group 'root'
        mode '0644'
        variables(files: includes(sub_dir))
        notifies :restart, "service[#{node['dhcp']['service_name']}]", :delayed
      end
    end

    #
    # Escape some special characters
    #
    # escape  . -> - and / -> _
    # so 1.1/3 -> 1-1_3
    #
    def escape(name)
      name.tr('.', '-').tr('/', '_')
    end

    module_function :escape
  end
end
