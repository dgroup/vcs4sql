require_relative "../sqlite_test"
require_relative "../../lib/vcs4sql/sqlite/migration"

class MigrationTest < Vcs4sql::SqliteTest

  test "setup" do
    file = ".tmp/00-setup.db"
    Vcs4sql::Sqlite::Migration.new(file).send(:install_vcs4sql)
    assert_equal(
      2,
      count(
        "select count(*)
         from sqlite_master
         where
          type = 'table'
          and name in ('changelog', 'changeloglock')",
        file
      ),
      "2 tables (changelog, changeloglock) are exists in database"
    )
  end

  test "upgrade files with multiple statements" do
    file = ".tmp/01-upgrade-multiple-statements.db"
    Vcs4sql::Sqlite::Migration.new(file).upgrade
  end
end
