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
