module Dhcp
  module Cookbook
    module TemplateHelpers
      def nil_or_empty?(property)
        return true if property.nil? || (property.respond_to?(:empty?) && property.empty?)

        false
      end

      def property_array(property)
        return property if property.is_a?(Array)

        [property]
      end

      def property_collection(property)
        property.map { |p| p.is_a?(Array) ? p : p.split(' ', 2) }
      end

      def property_collection_sorted(property)
        property.sort.map { |p| p.is_a?(Array) ? p : p.split(' ', 2) }
      end
    end
  end
end
