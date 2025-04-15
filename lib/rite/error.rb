# frozen_string_literal: true

module Rite
  # Encapsulating any errors that occur during validation.
  class Error < StandardError
    include Enumerable

    attr_reader :issues

    def initialize(issues = [])
      super()
      @issues = issues
    end

    def message
      'Validation failed'
    end

    # Iterates all issues and yields them in the order they were assigned.
    # @yield [Rite::Issue] Iterates each issue that caused this error.
    def each(&block)
      issues.each(&block)
    end

    # Add an issue or multiple issues.
    # @param [Array, Rite::Issue] issue the new issue to add to this error.
    def <<(issue)
      case issue
      when Array
        self.issues += issue
      else
        self.issues << issue
      end
    end
  end
end
