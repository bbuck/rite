# Rite

Define validators for Ruby classes and objects. Rite provides a simple, chainable
validator solution based on the principles of functional design: small, composable
validators used to build complex validation logic.

It starts with defining a small validator, like a validating type:

```ruby
string_validator = Rite.define_validator do
  validate do |value|
    value.is_a?(String)
  end

  failure_message '"%value" must be a string'
end
```

And now we can use it to validate some input:

```ruby
some_value = get_data_from_somewhere
if string_validator.valid?(some_value)
  # It's a string!
else
  # It's not a string!
  puts string_validator.failure_message(some_value)
end
```

But it's obvious this is overkill just to perform a simple `#is_a?` call. That's
what `Rite::Passage` solves -- chaining. We usually don't want to verify just
type in real world applications, we may want to verify that it matches some
expected format:

(NOTE: This API is not yet implemented and subject to change)

```ruby
ssn_validator = Rite::Validators
  .string # .is_a?(String)
  .matches(/\d{3}=\d{2}-\d{4}/) # .matches?(regex)
  .required # !.nil? && .length > 0
```

```ruby
positive_integers = Rite::Validators
  .integer # .is_a?(Integer)
  .greater_than(0, :or_equal) # >= 0
  .required # !.nil? && .length > 0
```

These validators create "chains" that will run the value through multiple
validators. These passages can also be used to chain other passages!

```ruby
valid_ssn_validator = Rite::Validators
  .with(ssn_validator)
  .not_equal('000-00-0000')
```

Or you can use specialized validtors to inject transformations to the output:

````ruby
ssn_validator = Rite::Validators
  .string # -> '"value" was expected to be String'
  .matches(/\d{3}=\d{2}-\d{4}/) # -> '"value" did not match expected format'
  .required # -> 'cannot be nil or blank'
  .message('"%value" is not a valid SSN') # -> '"value" is not a valid SSN"
```

## Roadmap to v1

- [x] gemspec
- [x] Validator base class
- [ ] Basic validators
  - [ ] class validator
  - [ ] value validator
  - [ ] required validator
  - [ ] numeric validator
  - [ ] hash validator
  - [ ] array validator
- [ ] Passage
- [ ] "Friendly" DSL
  - [ ] DSL for validator
    - [x] define validate function
    - [x] define custom failure message
    - [ ] define error handling

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rite'
````

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rite

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bbuck/rite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bbuck/rite/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rite project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bbuck/rite/blob/master/CODE_OF_CONDUCT.md).
