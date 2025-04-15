# frozen_string_literal: true

module Rite
  module Validators
    class String < Base
      refinement :min do
        checker { |value:, length:| value.length >= length }
        build_issue do |value:, path:, length:|
          Rite::TypeIssue.new(
            path:,
            expected: "string #{length} or longer",
            received: "string #{value.length}",
          )
        end
      end

      def execute(context)
        unless context.value.is_a?(::String)
          raise Rite::Error.new([
            Rite::TypeIssue.new(expected: 'String', received: context.value, path: context.path, message:),
          ])
        end
        super
      end

      def inspect_type
        'String'
      end
    end
  end
end
