# frozen_string_literal: true

require 'active_support/all'

# CaseFormatter allows you to convert from and to snake_case and camelCase
# It support nested elements as well, such as Arrays and Hashes
module CaseFormatter
  extend ActiveSupport::Concern

  included do
    def snake_to_camel_case(obj)
      case obj
      when String
        obj.camelize(:lower)
      when Symbol
        obj.to_s.camelize(:lower).to_sym
      when Hash
        obj.deep_transform_keys { |key| key.to_s.camelize(:lower).to_sym }
      when Array
        obj.map { |item| snake_to_camel_case(item) }
      else
        raise ArgumentError, "Unexpected type for case conversion: #{obj.class}"
      end
    end

    def camel_to_snake_case(obj)
      case obj
      when String
        obj.underscore
      when Symbol
        obj.to_s.underscore.to_sym
      when Hash
        obj.deep_transform_keys { |key| key.to_s.underscore.to_sym }
      when Array
        obj.map { |item| camel_to_snake_case(item) }
      else
        raise ArgumentError, "Unexpected type for case conversion: #{obj.class}"
      end
    end
  end
end
