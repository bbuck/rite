# frozen_string_literal: true

module Rite
  class Context
    attr_accessor :value, :path, :optional, :issues

    def initialize(value:, path:)
      self.value = value
      self.path = path
      self.optional = false
      self.issues = []
    end

    # @param [Rite::Refinement] refinmenet the refinement to verify against the
    #   current context
    def check(refinement, args)
      refinement_args = args[:args] || []
      refinement_kwargs = args[:kwargs] || {}
      valid = refinement.checker.call(*refinement_args, value:, **refinement_kwargs)
      return valid if valid
      issue_args = refinement.issue_args.call(*refinement_args, value:, **refinement_kwargs)
      self.issues << refinement.to_issue(
        *(issue_args[:args] || []),
        path:,
        **(issue_args[:kwargs] || {}),
      )
    end
  end
end
