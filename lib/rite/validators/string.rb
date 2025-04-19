# frozen_string_literal: true

module Rite
  module Validators
    class String < Instance
      # Source: https://github.com/colinhacks/zod
      EMAIL_PATTERN = /^(?!\.)(?!.*\.\.)([A-Z0-9_'+\-\.]*)[A-Z0-9_+-]@([A-Z0-9][A-Z0-9\-]*\.)+[A-Z]{2,}$/i;

      def initialize(message:)
        super(klass: ::String, message:)
      end

      # Validates that the string's length is at least the specified length.
      refinement :min, [:length] do
        check { |value:, length:| value.length >= length }
        build_issue do |value:, path:, length:|
          Rite::TypeIssue.new(
            path:,
            expected: "string #{length} or longer",
            received: "string #{value.length}",
          )
        end
      end

      # Validates that the string's length is at most the specified length or
      # less.
      refinement :max, [:length] do
        check { |value:, length:| value.length <= length }
        build_issue do |value:, length:, path:|
          Rite::TypeIssue.new(
            path:,
            expected: "string #{length} or shorter",
            received: "string #{value.length}",
          )
        end
      end

      refinement :matches, [:pattern] do
        check { |value:, pattern:, **kwargs| value.match?(pattern) }
        build_issue do |value:, path:, message: nil, **kwargs|
          Rite::TypeIssue.new(
            path:,
            expected: message,
            received: value,
            message:,
          )
        end
      end

      # Validates that the string looks like an email.
      def email(message: nil)
        matches(pattern: EMAIL_PATTERN, message: "expected email")
      end

      # Validates that the string's length falls within the given range.
      def within(range:)
        raise ArgumentError, "invalid range provided" unless range.is_a?(Range)
        min(length: range.begin).max(length: range.end)
      end
    end
  end
end
