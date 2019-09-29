#!/bin/bash

set -euo pipefail

version=$(cat lib/swiftformat/gem_version.rb | grep -o "\d\.\d\.\d")

echo "Releasing version ${version}"

echo "Releasing to rubygems.org"
bundle exec rake release

echo "Releasing to GitHub Package Registry"
gem push \
    --key github \
    --host https://rubygems.pkg.github.com/garriguv \
    pkg/danger-swiftformat-${version}.gem