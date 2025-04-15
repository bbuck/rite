# frozen_string_literal: true

module Rite
  class Result
    class << self
      def success(value)
        new(value:)
      end

      def failed(error)
        new(error:)
      end
    end

    attr_reader :value, :error

    def initialize(value: nil, error: nil)
      @value = value
      @error = error
    end

    def success?
      error.nil?
    end

    def failed?
      !success?
    end
  end
end
