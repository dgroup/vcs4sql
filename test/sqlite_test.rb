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

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "vcs4sql"
require "sqlite3"
require "active_support"
require "minitest/autorun"
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |rb| require(rb) }

module Vcs4sql
  class SqliteTest < ActiveSupport::TestCase
    # Fetches first column value from first result's row
    def first(sql, file)
      conn = SQLite3::Database.new file
      conn.results_as_hash = true
      conn.query(sql).first.values.first
    end

    # Fetches first values from all result's row
    def column(sql, file)
      conn = SQLite3::Database.new file
      conn.results_as_hash = true
      conn.query(sql).map { |r| r.values.first }
    end
  end
end
