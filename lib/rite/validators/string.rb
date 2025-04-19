# frozen_string_literal: true

module Rite
  module Validators
    class String < Instance
      EMAIL_REGEX = /^(?!\.)(?!.*\.\.)([A-Z0-9_'+\-\.]*)[A-Z0-9_+-]@([A-Z0-9][A-Z0-9\-]*\.)+[A-Z]{2,}$/i;

      def initialize(message:)
        super(klass: ::String, message:)
      end

      refinement :min, [:length] do
        checker { |value:, length:| value.length >= length }
        build_issue do |value:, path:, length:|
          Rite::TypeIssue.new(
            path:,
            expected: "string #{length} or longer",
            received: "string #{value.length}",
          )
        end
      end

      refinement :max, [:length] do
        checker { |value:, length:| value.length <= length }
        build_issue do |value:, length:, path:|
          Rite::TypeIssue.new(
            path:,
            expected: "string #{length} or shorter",
            received: "string #{value.length}",
          )
        end
      end

      refinement :email do
        checker { |value:| value.match?(EMAIL_REGEX) }
        build_issue do |value:, path:|
          Rite::TypeIssue.new(
            path:,
            expected: "valid email",
            received: value,
          )
        end
      end

      # Validates that the string's length falls within the given range.
      def within(range:)
        raise ArgumentError, "invalid range provided" unless range.is_a?(Range)
        min(length: range.begin).max(length: range.end)
      end
    end
  end
end
