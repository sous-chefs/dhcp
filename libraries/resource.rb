module Dhcp
  module Cookbook
    module ResourceHelpers
      # Create a list resource for the present conf_dir unless it already exists in the resource collection
      def init_list_resource(directory)
        create_list_resource(directory) unless list_resource_exist?(directory)
      end

      # Add the caller configuration resource to the relevant list for the directory it is being created in
      def add_to_list_resource(directory, config_file)
        manage_list_resource(directory, config_file, :add)
      end

      # Remove the caller configuration resource from the relevant list for the directory it is being created in
      def remove_from_list_resource(directory, config_file)
        manage_list_resource(directory, config_file, :remove)
      end

      private

      # Check if the list resource is already present in the resource collection
      def list_resource_exist?(directory)
        !find_resource!(:template, "#{directory}/list.conf").nil?
      rescue Chef::Exceptions::ResourceNotFound
        false
      end

      # Declare resources to create a list resource and it's containing directory
      def create_list_resource(directory)
        with_run_context(:root) do
          declare_resource(:directory, directory)
          declare_resource(:template, "#{directory}/list.conf") do
            cookbook 'dhcp'
            source 'list.conf.erb'

            owner new_resource.owner
            group new_resource.group
            mode new_resource.mode

            variables['files'] ||= []

            action :nothing
            delayed_action :create
          end
        end
      end

      # Find the include list resource for the relevant directory and return it
      def list_resource(directory)
        find_resource!(:template, "#{directory}/list.conf")
      end

      # Manage addition and removal from an include list template ensuring it is already declared in the resource collection
      def manage_list_resource(directory, config_file, action)
        init_list_resource(directory)
        files = list_resource(directory).variables['files']

        case action
        when :add
          files.push(config_file) unless files.include?(config_file)
        when :remove
          files.delete(config_file) if files.include?(config_file)
        end
      end
    end
  end
end
