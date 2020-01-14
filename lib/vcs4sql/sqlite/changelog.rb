require "sqlite3"

module Vcs4sql
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

  end
end
