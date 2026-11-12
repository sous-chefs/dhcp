# frozen_string_literal: true

property :comment, String,
          description: 'Unparsed comment to add to the configuration file'

property :conf_dir, String,
          default: lazy { dhcpd_config_resource_directory(ip_version, declared_type) },
          description: 'Directory to create configuration file in'

property :cookbook, String,
          default: 'dhcp',
          description: 'Template source cookbook'

property :owner, String,
          default: lazy { dhcpd_user },
          description: 'Generated file owner'

property :group, String,
          default: lazy { dhcpd_group },
          description: 'Generated file group'

property :mode, String,
          default: '0640',
          description: 'Generated file mode'
