# frozen_string_literal: true

module Intercept
  module Strategy
    class Replace
      attr_reader :replace_value

      def initialize(replace_value)
        @replace_value = replace_value.dup
      end

      def process(value)
        if value.nil? || value.empty?
          value
        else
          replace_value
        end
      end
    end
  end
end
