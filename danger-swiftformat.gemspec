# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swiftformat/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'danger-swiftformat'
  spec.version       = Swiftformat::VERSION
  spec.authors       = ['Vincent Garrigues']
  spec.email         = ['vincent.garrigues@gmail.com']
  spec.description   = %q{A danger plugin for checking Swift formatting using SwiftFormat.}
  spec.summary       = %q{A danger plugin for checking Swift formatting using SwiftFormat.}
  spec.homepage      = 'https://github.com/garriguv/danger-swiftformat'
  spec.license       = 'MIT'
  spec.metadata      = { "github_repo" => "ssh://github.com/garriguv/danger-ruby-swiftformat" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 12.3'

  # Testing support
  spec.add_development_dependency 'rspec', '~> 3.7'

  # Linting code and docs
  spec.add_development_dependency "rubocop", "~> 0.52"
  spec.add_development_dependency "yard", "~> 0.9"

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'

  # If you want to work on older builds of ruby
  spec.add_development_dependency 'listen', '~> 3.1'

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency 'pry'
end
