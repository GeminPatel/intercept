# frozen_string_literal: true

module Intercept
  module Strategy
    class WhiteList
      attr_reader :white_list, :fallback_strategy

      def initialize(white_list, fallback_strategy = nil)
        @white_list = white_list
        @fallback_strategy = fallback_strategy
      end

      def process_identities(identities)
        return [] if identities.blank?

        white_listed_identities = white_list_identities(identities)

        if fallback_strategy && white_listed_identities.empty?
          fallback_strategy.process_identities(identities)
        else
          white_listed_identities
        end
      end

      private

      def white_list_identities(identities)
        identities.select do |identity|
          white_list.find do |regex|
            Regexp.new(regex).match?(identity)
          end
        end.compact.uniq
      end
    end
  end
end