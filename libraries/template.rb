module Dhcp
  module Template
    module Helpers
      def nil_or_empty?(property)
        return true if property.nil? || property.empty?

        false
      end

      def property_array(property)
        return property if property.is_a?(Array)

        [property]
      end
    end
  end
end
