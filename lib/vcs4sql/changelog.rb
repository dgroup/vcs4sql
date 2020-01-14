require "sqlite3"

module Vcs4sql::Sqlite
  class Changelog
    attr_reader :id, :file, :version, :md5sum, :sql

    def initialize(file, applied, version, md5sum, sql, id: 0)
      @file = file
      @applied = applied
      @version = version
      @md5sum = md5sum
      @sql = sql
      @id = id
    end

    # @todo #/DEV Raise the exception in case if
    #  - this.* are empty or null
    #  - conn is empty or null
    def apply(conn)
      # @todo #/DEV Wrap the sql's execution to separate blocks which will:
      #  - catch the error
      #  - provide the detailed description
      #  - populate the error code
      conn.execute_batch @sql
      conn.execute "insert /* ll.sqlid:#{__FILE__}:#{__method__} */
                    into changelog(file,version,md5sum,applied,sql) values(?,?,?,?,?)",
                   @file, @version, @md5sum, @applied, @sql
    end

    def to_s
      "#{@version}: #{@file} #{@md5sum}"
    end

    def matched(exist)
      change.md5sum == exist.md5sum
    end

    def alert(exist)
      raise <<-MSG
vcs4sql-001: Version '#{change.version}' has checksum mismatch.

The possible root cause is that the file with migration, which was applied already, got changed recently.
As a workaround, you may change the md5sum in the database in case if these changes are minor
and don't affect the structure:
update changelog set md5sum='#{change.md5sum}' where id=#{exist.id}

In case if changes are major and affect the database structure then they should be reverted
and introduce it as a new change.

Expected '#{change.version}' version from '#{change.file}' (#{change.md5sum}) has SQL:
#{change.sql}
.............................................................................................
Existing '#{exist.version}' version from '#{exist.file}' (#{exist.md5sum}) has SQL:
#{exist.sql}
.............................................................................................
      MSG
    end
  end
end
