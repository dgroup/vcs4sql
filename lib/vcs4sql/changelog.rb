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
                    into changelog(file,version,md5sum,applied,sql)
                    values(?,?,?,?,?)",
                   @file, @version, @md5sum, @applied, @sql
    end

    def to_s
      "#{@version}: #{@file} #{@md5sum}"
    end

    def matches(exist)
      @md5sum == exist.md5sum
    end
  end
end
