# frozen_string_literal: true

module Intercept
  module Strategy
    class Replace
      attr_reader :replace_value

      def initialize(replace_value)
        @replace_value = replace_value
      end

      def process(value)
        if value.nil? || value.empty?
          value
        else
          replace_value.call
        end
      end

      private

      def parse_replace_value(replace_value)
        if replace_value.respond_to?(:call)
          replace_value
        else
          raise '@param replace_value must respond to #call'
        end
      end
    end
  end
end
