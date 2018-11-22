# frozen_string_literal: true

module Intercept
  module Strategy
    class Mapper
      attr_reader :bucket_map, :fallback_strategy

      def initialize(bucket_map, fallback_strategy = nil)
        @bucket_map = parse_bucket_map bucket_map
        @fallback_strategy = fallback_strategy
      end

      def process(value)
        return value if value.nil? || value.empty?

        mapped_value = map_value(value)

        if fallback_strategy && mapped_value.empty?
          fallback_strategy.process(value)
        else
          mapped_value
        end
      end

      private

      def parse_bucket_map(bucket_map)
        if bucket_map.respond_to?(:call)
          bucket_map
        else
          raise '@param bucket_map must respond to #call'
        end
      end

      def map_value(value)
        value.map do |unit|
          bucket_map.call.find do |bucket, _|
            bucket.match?(unit)
          end&.fetch(1)
        end.compact.uniq
      end
    end
  end
end
