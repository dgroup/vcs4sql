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

require_relative "../../sqlite_test"
require_relative "../../../lib/vcs4sql/sqlite/migration"

class MigrationTest < Vcs4sql::SqliteTest
  test "setup" do
    file = "test/resources/00-setup/sqlite.db"
    Vcs4sql::Sqlite::Migration.new(file).send(:install_vcs4sql)
    assert_equal(
      2,
      first(
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
      "phones_owner_fk",
      first(
        "select name
        from sqlite_master
        where
          type = 'index'
          and tbl_name = 'phones'
          and name like '%fk'",
        file
      ),
      "The table 'phones' has expected index for column 'owner'"
    )
  end

  test "upgrade files with test data" do
    file = "test/resources/02-upgrade-with-test-data/sqlite.db"
    Vcs4sql::Sqlite::Migration.new(file).upgrade(File.dirname(file), true)
    assert_equal(
      ["555 555 003", "555 555 033"],
      column("select p.number from phones p where p.owner = 3", file),
      "The user with id=3 has 2 phone numbers"
    )
  end

  # @todo #/DEV The test should simulate the case when change set was applied to
  #  database, then someone have changed the file accidentally, committed the
  #  changes, and migration was triggered in prod.
  test "got exception due to checksum mismatch" do
    assert true, "not implemented yet"
  end
end
