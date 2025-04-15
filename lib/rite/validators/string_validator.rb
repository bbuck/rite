# frozen_string_literal: true

module Rite
  module Validators
    class StringValidator < Validator
      refinement :min do
        checker { |value:, length:| value.length >= length }
        issue Rite::TypeIssue
        issue_args do |value:, length:|
          {
            kwargs: {
              expected: "string #{length} or longer",
              received: "string #{value.length}",
            },
          }
        end
      end

      protected

      def execute(context)
        unless context.value.is_a?(String)
          raise Rite::Error.new([
            Rite::TypeIssue.new(expected: 'String', received: context, path: context.path, message:),
          ])
        end
        super(context)
      end
    end
  end
end
