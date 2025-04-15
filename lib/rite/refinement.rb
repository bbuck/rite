# frozen_string_literal: true

module Rite
  class Refinement
    class << self
      def build(&block)
        new.tap do |refinement|
          refinement.instance_eval(&block)
        end
      end
    end

    def initialize
      @checker = nil
      @issue = Rite::Issue
      @issue_args = -> { {} }
    end

    def checker(&block)
      if block_given?
        @checker = block
      else
        @checker
      end
    end

    def issue(klass)
      @issue_klass = klass
    end

    def issue_args(&block)
      if block_given?
        @issue_args = block
      else
        @issue_args
      end
    end

    def to_issue(*args, **kwargs)
      @issue_klass.new(*args, **kwargs)
    end
  end
end
