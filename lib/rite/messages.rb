# frozen_string_literal: true

module Rite
  MESSAGES = {
    invalid_type: ->(issue) { "Expected #{issue.expected}, got  #{issue.received}" },
    unrecognized_key: -> { "unrecognized key" },
    invalid_union: -> { "invalid union" },
    invalid_enum_value: -> { "invalid enum value" },
    invalid_arguments: -> { "invalid arguments" },
    invalid_return_type: -> { "invalid return type" },
    invalid_date: -> { "invalid date" },
    invalid_string: -> { "invalid string" },
    too_small: -> { "too small" },
    too_big: -> { "too big" },
    not_multiple_of: -> { "not multiple of" },
    custom: -> { "custom" },
  }
end
