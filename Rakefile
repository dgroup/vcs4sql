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
require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"
require "fileutils"
require "xcop/rake_task"

task default: %i[cleanup test rubocop xcop]

desc "Run tests"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
  t.warning = false
end
RuboCop::RakeTask.new

desc "Validate all XML/XSL/XSD/HTML files for formatting"
Xcop::RakeTask.new :xcop do |task|
  task.license = "license.txt"
  task.includes = %w[**/*.xml **/*.xsl **/*.xsd **/*.html]
  task.excludes = %w[target/**/* coverage/**/* wp/**/*]
end

task :cleanup do
  Dir.glob("test/resources/**/*.db").each { |f| File.delete(f) }
end

task bump: %w[bump:bundler bump:ruby bump:year]

namespace :bump do
  task :bundler do
    version = Gem.latest_version_for("bundler").to_s
    replace_in_file ".circleci/config.yml", /bundler -v (\S+)/ => version
    replace_in_file ".travis.yml", /bundler -v (\S+)/ => version
    replace_in_file "Gemfile.lock", /^BUNDLED WITH\n\s+([\d\.]+)$/ => version
  end

  task :ruby do
    lowest = RubyVersions.lowest_supported
    lowest_minor = RubyVersions.lowest_supported_minor
    latest = RubyVersions.latest

    replace_in_file "vcs4sql.gemspec",
                    /ruby_version = ">= (.*)"/ => lowest

    replace_in_file ".rubocop.yml", /TargetRubyVersion: (.*)/ => lowest_minor
    replace_in_file ".circleci/config.yml",
                    %r{circleci/ruby:([\d\.]+)} => latest

    travis = YAML.safe_load(open(".travis.yml"))
    travis["rvm"] = RubyVersions.latest_supported_patches + ["ruby-head"]
    IO.write(".travis.yml", YAML.dump(travis))
  end

  task :year do
    sh "grep -q -r '2020-#{Date.today.strftime('%Y')}' \
    --include '*.rb' \
    --include '*.txt' \
    --include 'Rakefile' \
    ."
  end
end

require "date"
require "open-uri"
require "yaml"

def replace_in_file(path, replacements)
  contents = IO.read(path)
  orig_contents = contents.dup
  replacements.each do |regexp, text|
    contents.gsub!(regexp) do |match|
      match[regexp, 1] = text
      match
    end
  end
  IO.write(path, contents) if contents != orig_contents
end

module RubyVersions
  class << self
    def lowest_supported
      "#{lowest_supported_minor}.0"
    end

    def lowest_supported_minor
      latest_supported_patches.first[/\d+\.\d+/]
    end

    def latest
      latest_supported_patches.last
    end

    def latest_supported_patches
      patches = [versions[:stable], versions[:security_maintenance]].flatten
      patches.map(&Gem::Version.method(:new)).sort.map(&:to_s)
    end

    private

    def versions
      @_versions ||= begin
                       yaml = URI.open(
                         "https://raw.githubusercontent.com/ruby/www.ruby-lang.org/master/_data/downloads.yml"
                       )
                       YAML.safe_load(yaml, symbolize_names: true)
                     end
    end
  end
end
