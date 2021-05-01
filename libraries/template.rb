module Dhcp
  module Cookbook
    module TemplateHelpers
      def nil_or_empty?(*values)
        values.any? { |v| v.nil? || (v.respond_to?(:empty?) && v.empty?) }
      end

      def property_array(property)
        return property if property.is_a?(Array)

        [property]
      end

      def property_collection(property)
        property.map { |p| p.is_a?(Array) ? p : p.split(' ', 2) }
      end

      def property_collection_sorted(property)
        property_collection(property.sort)
      end
    end
  end
end
