# frozen_string_literal: true

require_relative 'lib/rite/version'

Gem::Specification.new do |spec|
  spec.name = 'rite'
  spec.version = Rite::VERSION
  spec.authors = ['Brandon Buck']
  spec.email = ['lordizuriel@gmail.com']

  spec.summary = 'Validation library for Ruby objects.'
  spec.description = 'Easily define complex validator pipelines and rules for Ruby classes/hashes/anything.'
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  # spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/bbuck/rite'
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir        = 'exe'
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # dependencies
  spec.add_development_dependency 'pry', '~> 0.13.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
