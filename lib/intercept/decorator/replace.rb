# frozen_string_literal: true

module Intercept
  module Decorator
    class Replace
      attr_reader :replace_value

      def initialize(replace_value)
        @replace_value = parse_replace_value replace_value
      end

      def decorate(_)
        replace_value.call
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
