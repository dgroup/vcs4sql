# frozen_string_literal: true

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

require "securerandom"
require "digest"
require "fileutils"
require_relative "../changelog"
require_relative "expected"
require_relative "applied"

# The database schema migration
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
module Vcs4sql
  module Sqlite
    class Migration
      def initialize(file)
        FileUtils.mkdir_p File.dirname(file)
        @conn = SQLite3::Database.new file
        @conn.results_as_hash = true
      end

      # @param home
      # @param testdata
      def upgrade(home, testdata=false)
        install_vcs4sql
        existing = Vcs4sql::Sqlite::Applied.new @conn
        expected = Vcs4sql::Sqlite::Expected.new home, testdata
        if existing.empty?
          expected.apply_all @conn
        else
          expected.apply_mismatch existing, @conn
        end
      end

      private

      def install_vcs4sql
        # @todo #/DEV Lock the upgrade procedure in order to avoid the cases
        #  when multiple processes are going to modify/upgrade the same database
        #  schema. No concurrent upgrades is allowed so far.
        @conn.execute_batch2 <<~SQL
          create table if not exists changelog (
              id        integer primary key autoincrement,
              file      text not null,
              applied   timestamp default current_timestamp,
              version   integer unique not null,
              md5sum    text not null,
              sql       text not null
          );
          create table if not exists changeloglock (
              id text primary key,
              locked integer,
              lockedby text
          );
        SQL
      end
    end
  end
end
