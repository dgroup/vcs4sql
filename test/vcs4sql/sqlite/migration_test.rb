require_relative "../../sqlite_test"
require_relative "../../../lib/vcs4sql/sqlite/migration"

class MigrationTest < Vcs4sql::SqliteTest
  test "setup" do
    file = "test/resources/00-setup/sqlite.db"
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
    file = "test/resources/01-upgrade-multiple-statements/sqlite.db"
    Vcs4sql::Sqlite::Migration.new(file).upgrade File.dirname(file)
    assert_equal(
      ["555 555 003", "555 555 033"],
      column("select p.number from phones p where p.owner = 3", file),
      "The user with id=3 has 2 phone numbers"
    )
  end
end
