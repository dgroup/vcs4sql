$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "vcs4sql"
require "sqlite3"
require "active_support"
require "minitest/autorun"
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |rb| require(rb) }

module Vcs4sql
  class Test < ActiveSupport::TestCase
    def count(sql, file)
      conn = SQLite3::Database.new file
      conn.results_as_hash = true
      conn.query(sql).first.values.first
    end
  end
end
