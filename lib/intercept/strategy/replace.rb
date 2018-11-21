# frozen_string_literal: true

module Intercept
  module Strategy
    class Replace
      attr_reader :replace_identities

      def initialize(replace_identities)
        @replace_identities = replace_identities.dup
      end

      def process_identities(identities)
        if identities.blank?
          []
        else
          replace_identities
        end
      end
    end
  end
end
