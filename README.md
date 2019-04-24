# danger-swiftformat [![Build Status](https://travis-ci.org/garriguv/danger-ruby-swiftformat.svg?branch=master)](https://travis-ci.org/garriguv/danger-ruby-swiftformat) [![Gem Version](https://badge.fury.io/rb/danger-swiftformat.svg)](https://rubygems.org/gems/danger-swiftformat)

A [Danger] plugin to check Swift formatting using [SwiftFormat].

This plugin is heavily inspired by [danger-swiftlint].

## Installation

Add this line to your Gemfile:

    gem 'danger-swiftformat'

[SwiftFormat] also needs to be installed before you run Danger.

## Usage

Add this to your `Dangerfile`

```ruby
swiftformat.check_format
```

By default, danger-swiftformat will check added and modified files.

If you want errors to fail Danger, you can use the `fail_on_error` option:

```ruby
swiftformat.check_format(fail_on_error: true)
```

You can specify the `swiftformat` binary using the `binary_path` parameter:

```ruby
swiftformat.binary_path = "/path/to/swiftformat"
```

You can specify additional `swiftformat` arguments using the `additional_args` parameter:

```ruby
swiftformat.additional_args = "--indent tab --self insert"
```

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

[Danger]: https://danger.systems/ruby/
[SwiftFormat]: https://github.com/nicklockwood/SwiftFormat
[danger-swiftlint]: https://github.com/ashfurrow/danger-ruby-swiftlint
