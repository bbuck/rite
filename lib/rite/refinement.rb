# frozen_string_literal: true

module Rite
  class Refinement
    # Arguments for a refinement.
    class Args
      attr_reader :kwargs

      def initialize(kwargs)
        @kwargs = kwargs || {}
      end
    end

    class << self
      def build(&block)
        new.tap do |refinement|
          refinement.instance_eval(&block)
        end
      end
    end

    def initialize
      @checker = nil
      @halt_on_failure = false
      @issue_builder = ->(path:) {  Rite::Issue.new(code: :unknown, path:, message: nil) }
    end

    # Assigns a checker Proc that can be called to validate a value against
    # specific conidtions.
    # This function powers the Refinement DSL.
    def check(&block)
      @checker = block
    end

    def halt_on_failure
      @halt_on_failure = true
    end

    # Assigns a Proc to build the issue should this refinement check fail.
    # This function powers the Refinement DSL.
    def build_issue(&block)
      @issue_builder = block
    end

    # Executes the refinement check on the arguments.
    def validate(**kwargs)
      @checker.call(**kwargs)
    end

    # Notes that validations should halt if this refinment fails.
    def halt_on_failure?
      @halt_on_failure
    end

    # Constructs an issue from this refinement.
    def to_issue(**kwargs)
      @issue_builder.call(**kwargs)
    end
  end
end
