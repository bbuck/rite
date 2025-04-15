# Rite

![Rspec](https://github.com/bbuck/rite/workflows/Rspec/badge.svg)

Define validators for Ruby classes and objects. Rite provides a simple, chainable
validator solution based on the principles of functional design: small, composable
validators used to build complex validation logic.

## Roadmap to v1

- [x] gemspec
- [x] Validator base class
- [ ] Basic validators
  - [ ] type validator
  - [ ] value validator
  - [ ] required validator
  - [ ] numeric validator
  - [ ] hash validator
  - [ ] array validator
- [ ] Transformers (chainable with validators but transform data/error messages)
- [ ] Passage
- [ ] "Friendly" DSL
  - [ ] DSL for validator
    - [x] define validate function
    - [x] define custom failure message
    - [ ] define error handling
  - [ ] DSL for transformer
  - [ ] DSL for Passage

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rite'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rite

## Usage

(NOTE: This API is not yet implemented and subject to change)

```ruby
# Define a schema for SSNs
ssn_schema = Rite
  .string
  .matches(/\d{3}-\d{2}-\d{4}/)

ssn_schema.parse!('apple') # => raises Rite::Error
ssn_schema.parse('000-00-0000') # => returns Rite::Result
# result.success? => true
# result.value => '000-00-0000'
```

```ruby
# Define the schema
positive_integer_schema = Rite
  .integer
  .positive

# validate data with it
positive_integer_schema.parse!(1) # => 1
positive_integer_schema.parse(-8) # => Rite::Result
# result.success? => false
# result.failed? => true
# result.error => Rite::Error
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bbuck/rite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bbuck/rite/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rite project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bbuck/rite/blob/master/CODE_OF_CONDUCT.md).
