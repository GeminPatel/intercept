# frozen_string_literal: true

module Intercept
  module Strategy
    class WhiteList
      attr_reader :white_list, :fallback_strategy

      def initialize(white_list, fallback_strategy = nil)
        @white_list = parse_white_list white_list
        @fallback_strategy = fallback_strategy
      end

      def process(value)
        return value if value.nil? || value.empty?

        white_listed_value = white_list_value(value)

        if fallback_strategy && white_listed_value.empty?
          fallback_strategy.process(value)
        else
          white_listed_value
        end
      end

      private
      
      def parse_white_list(white_list)
        white_list.map do |entity|
          if String === entity
            Regexp.new entity
          elsif Regexp === entity
            entity
          else
            raise '@param white_list elements must be [String, Regexp]'
          end
        end
      end

      def white_list_value(value)
        value.select do |unit|
          white_list.find do |regex|
            regex.match?(unit)
          end
        end.compact.uniq
      end
    end
  end
end
