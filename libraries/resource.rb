module Dhcp
  module Cookbook
    module ResourceHelpers
      def create_list_resource(directory)
        with_run_context(:root) do
          edit_resource(:directory, directory)
          edit_resource(:template, "#{directory}/list.conf") do
            cookbook 'dhcp'
            source 'list.conf.erb'

            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode
            atomic_update true

            variables['files'] ||= []

            action :nothing
            delayed_action :create
          end
        end
      end

      def add_to_list_resource(directory, config_file)
        begin
          list = find_resource!(:template, "#{directory}/list.conf")
        rescue Chef::Exceptions::ResourceNotFound
          list = create_list_resource(directory)
        end

        list.variables['files'].push(config_file)
      end
    end
  end
end
