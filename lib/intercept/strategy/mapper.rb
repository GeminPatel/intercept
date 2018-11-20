# frozen_string_literal: true

module Intercept
  module Strategy
    class Mapper
      attr_reader :bucket_map, :fallback_strategy

      def initialize(bucket_map, fallback_strategy = nil)
        @bucket_map = bucket_map
        @fallback_strategy = fallback_strategy
      end

      def process_identities(identities)
        return [] if identities.blank?

        mapped_identities = map_identities(identities)

        if fallback_strategy && mapped_identities.empty?
          fallback_strategy.process_identities(identities)
        else
          mapped_identities
        end
      end

      private

      def map_identities(identities)
        identities.map do |identity|
          bucket_map.find do |bucket, _|
            Regexp.new(bucket).match?(identity)
          end&.second
        end.compact.uniq
      end
    end
  end
end