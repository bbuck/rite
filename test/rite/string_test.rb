# frozen_string_literal: true

require "test_helper"

module Rite
  class StringTest < Minitest::Test
    def test_inspect_type_is_string
      assert_equal "String", Rite.string.inspect_type
    end

    def test_parse_returns_result_with_status
      schema = Rite.string

      success = schema.parse("hello")
      failed = schema.parse(:hello)

      assert_equal "hello", success.value
      assert_nil success.error
      assert success.success?
      assert !success.failed?
      assert_nil failed.value
      assert_instance_of Rite::Error, failed.error
      assert !failed.success?
      assert failed.failed?
    end

    def test_fails_without_a_string_instance
      schema = Rite.string

      [nil, 1, [], {}, 1.0, false, :not_a_string].each do |value|
        assert_raises(Rite::Error) { schema.parse!(value) }
      end
    end

    def test_fails_with_invalid_type_issue_when_type_does_not_match
      schema = Rite.string

      result = schema.parse(:invalid)
      issue = result.error.issues.first
      assert_equal issue.code, :invalid_type
      assert_equal issue.expected, "String"
      assert_equal issue.received, "Symbol"
    end

    def test_passes_with_string_values
      schema = Rite.string
      alphabet = "abcdefghijklmnopqrstuvwxyz".chars

      (0..alphabet.length).each do |length|
        str = alphabet.take(length).join
        result = schema.parse!(str)
        assert_equal str, result
      end
    end

    def test_responds_expected_refinments
      schema = Rite.string

      [:min, :max, :email, :within].each do |method|
        assert_respond_to schema, method
      end
    end

    def test_min_requires_strings_longer_than_specified_length
      schema = Rite.string.min(length: 5)

      assert_raises(Rite::Error) { schema.parse!("abc") }
      assert_equal "abcde", schema.parse!("abcde")
      assert_equal "abcdef", schema.parse!("abcdef")
    end

    def test_max_requires_srings_shorter_than_specified_length
      schema = Rite.string.max(length: 5)

      assert_equal "abc", schema.parse!("abc")
      assert_equal "abcde", schema.parse!("abcde")
      assert_raises(Rite::Error) { schema.parse!("abcdef") }
    end

    def test_min_max_create_range_requirement
      schema = Rite.string.min(length: 3).max(length: 5)
      chars = "abcdefgh".chars

      (0..chars.length).each do |length|
        str = chars.take(length).join
        if str.length >= 3 && str.length <= 5
          assert_equal str, schema.parse!(str)
        else
          assert_raises(Rite::Error) { schema.parse!(str) }
        end
      end
    end

    def test_within_creates_range_requirement
      schema = Rite.string.within(range: 3..5)
      chars = "abcdefgh".chars

      (0..chars.length).each do |length|
        str = chars.take(length).join
        if str.length >= 3 && str.length <= 5
          assert_equal str, schema.parse!(str)
        else
          assert_raises(Rite::Error) { schema.parse!(str) }
        end
      end
    end

    def test_email_matches_email_like_strings
      schema = Rite.string.email

      [
        { input: 'apple', success: false },
        { input: 'apple@example.com', success: true },
        { input: 'a@b.c', success: false },
        { input: 'a@b.cd', success: true },
      ].each do |test_case|
        result = schema.parse(test_case[:input])
        assert_equal(
          test_case[:success],
          result.success?,
          "expected #{test_case[:input]} to#{test_case[:success] ? "" : " not"} be an email"
        )
      end
    end

    def test_matches_a_pattern
      schema = Rite.string.matches(pattern: /\d{3}-\d{2}-\d{4}/)

      [
        ["", false],
        ["1", false],
        ["12", false],
        ["123", false],
        ["123-", false],
        ["123-4", false],
        ["123-45", false],
        ["123-45-", false],
        ["123-45-6", false],
        ["123-45-67", false],
        ["123-45-678", false],
        ["123-45-6789", true],
      ].each do |(input, success)|
        if success
          assert_equal input, schema.parse!(input)
        else
          assert_raises(Rite::Error) { schema.parse!(input) }
        end
      end
    end
  end
end
