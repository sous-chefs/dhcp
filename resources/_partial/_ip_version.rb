# frozen_string_literal: true

property :ip_version, [Symbol, String],
          equal_to: [:ipv4, :ipv6, 'ipv4', 'ipv6'],
          coerce: proc { |ipv| ipv.is_a?(Symbol) ? ipv : ipv.to_sym },
          default: :ipv4,
          description: 'The IP version, 4 or 6'
