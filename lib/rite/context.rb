# frozen_string_literal: true

module Rite
  class Context
    attr_accessor :value, :path, :optional, :issues, :continue

    def initialize(value:, path:)
      self.value = value
      self.path = path
      self.optional = false
      self.issues = []
      self.continue = true
    end

    # Determines if the context should continue being validated.
    def continue?
      self.continue
    end

    # Instructs the context to ignore subsequent checks.
    def halt
      self.continue = false
    end

    # Determine if the state of the context is currently valid. A valid
    # context has no issues identified (potentially failed validations).
    def valid?
      issues.empty?
    end

    # @param [Rite::Refinement] refinmenet the refinement to verify against the
    #   current context
    def check(refinement, args)
      return unless continue?

      refinement_args = args[:args] || []
      refinement_kwargs = args[:kwargs] || {}
      return if refinement.check(*refinement_args, value:, **refinement_kwargs)
      self.issues << refinement.to_issue(
        *refinement_args,
        value:,
        path:,
        **refinement_kwargs,
      )
    end
  end
end
