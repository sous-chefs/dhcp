module Dhcp
  module Cookbook
    module TemplateHelpers
      def nil_or_empty?(property)
        return true if property.nil? || property.empty?

        false
      end

      def property_array(property)
        return property if property.is_a?(Array)

        [property]
      end

      def property_sorted_array(property)
        property.sort.map { |p| p.is_a?(Array) ? p : p.split(' ', 2) }
      end
    end
  end
end
