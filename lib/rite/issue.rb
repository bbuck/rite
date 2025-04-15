# frozen_string_literal: true

module Rite
  class Issue
    attr_reader :code, :path, :message

    def initialize(code:, path:, message: nil)
      @code = code
      @path = path
      @message = message
    end
  end

  class TypeIssue < Issue
    attr_reader :expected, :received

    def initialize(expected:, received:, **kwargs)
      super(code: :invalid_type, **kwargs)
      @expected = expected
      @received = received
    end
  end
end
