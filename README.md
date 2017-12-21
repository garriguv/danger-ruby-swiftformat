# danger-swiftformat [![Build Status](https://travis-ci.org/garriguv/danger-ruby-swiftformat.svg?branch=master)](https://travis-ci.org/garriguv/danger-ruby-swiftformat)

A [danger] plugin to check Swift formatting using [SwiftFormat].

This plugin is heavily inspired by [danger-swiftlint].

## Installation

    $ gem install danger-swiftformat

## Usage

Add the following to your `Gemfile`

    require 'danger-swiftformat'

In your `Dangerfile`

```ruby
swiftformat.binary_path = "/path/to/swiftformat" # optional, but recommended ;)
swiftformat.check_format(fail_on_error: true)
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

[danger]: https://danger.systems/ruby/
[SwiftFormat]: https://github.com/nicklockwood/SwiftFormat
[danger-swiftlint]: https://github.com/ashfurrow/danger-ruby-swiftlint
