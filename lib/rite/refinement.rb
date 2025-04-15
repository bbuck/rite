# frozen_string_literal: true

module Rite
  class Refinement
    # Positional arguments and keyword arguments for a refinement.
    Args = Struct.new(:args, :kwargs)

    class << self
      def build(&block)
        new.tap do |refinement|
          refinement.instance_eval(&block)
        end
      end
    end

    def initialize
      @checker = nil
      @issue_builder = ->(path:) {  Rite::Issue.new(code: :unknown, path:, message: nil) }
    end

    # Assigns a checker Proc that can be called to validate a value against
    # specific conidtions.
    # This function powers the Refinement DSL.
    def checker(&block)
      @checker = block
    end

    # Assigns a Proc to build the issue should this refinement check fail.
    # This function powers the Refinement DSL.
    def build_issue(&block)
      @issue_builder = block
    end

    # Executes the refinement check on the arguments.
    def check(*args, **kwargs)
      @checker.call(*args, **kwargs)
    end

    # Constructs an issue from this refinement.
    def to_issue(*args, **kwargs)
      @issue_builder.call(*args, **kwargs)
    end
  end
end
