# MIT License
#
# Copyright (c) 2020 Yurii Dubinka
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vcs4sql/version"

Gem::Specification.new do |spec|
  spec.name = "vcs4sql"
  spec.version = Vcs4sql::VERSION
  spec.authors = ["Yurii Dubinka"]
  spec.email = ["yurii.dubinka@gmail.com"]

  spec.summary = "Organizing version control for the database(s) in a simple, elegant way."
  spec.homepage = "https://github.com/dgroup/vcs4sql"
  spec.license = "MIT"

  spec.description = 'In the last few years, version control for database became best practice.
There are several implementations/ways for ruby, however, most of them are focused/dependent on particular
frameworks that restrict the migration outside the framework.
vcs4sql allows organizing version control for the database(s) in a simple,
elegant way without any dependencies on existing frameworks.'

  spec.post_install_message = "Thanks for installing vcs4sql '#{Vcs4sql::VERSION}'!
  Stay in touch with the community in Telegram: https://t.me/lazyleads
  Follow us on Twitter: https://twitter.com/lazylead
  If you have any issues, report to our GitHub repo: https://github.com/dgroup/vcs4sql"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/dgroup/vcs4sql/issues",
    "changelog_uri" => "https://github.com/dgroup/vcs4sql/releases",
    "source_code_uri" => "https://github.com/dgroup/vcs4sql",
    "homepage_uri" => "https://github.com/dgroup/vcs4sql"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = `git ls-files -z exe lib license.txt readme.md`.split("\x0")
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6.5"

  spec.add_runtime_dependency "fileutils", "~> 1.4.1"
  spec.add_runtime_dependency "sqlite3", "~> 1.4.2"

  spec.add_development_dependency "activesupport", "~> 6.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "debase", "~> 0.2.4.1"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "minitest-ci", "~> 3.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "0.78.0"
  spec.add_development_dependency "rubocop-minitest", "0.5.1"
  spec.add_development_dependency "rubocop-performance", "1.5.2"
  spec.add_development_dependency "ruby-debug-ide", "~> 0.7.0"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
  spec.add_development_dependency "xcop", "~> 0.6"
end
