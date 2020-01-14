# frozen_string_literal: true

require "securerandom"
require "digest"
require "fileutils"
require_relative "../changelog"
require_relative "expected"
require_relative "existing"

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
        existing = Vcs4sql::Sqlite::Existing.new @conn
        expected = Vcs4sql::Sqlite::Expected.new home, testdata
        if existing.empty?
          expected.apply_all(@conn)
        else
          version = -1
          expected.each_with_index do |change, i|
            break if existing.has(i)

            if change.matches existing.change(i)
              version = i
            else
              change.alert existing.change(i)
            end
          end
          expected.apply(version, @conn)
        end
      end

      private

      def install_vcs4sql
        # @todo #/DEV Lock the upgrade procedure in order to avoid the cases
        #  when multiple processes are going to modify/upgrade the same database
        #  schema. No concurrent upgrades is allowed so far.
        @conn.execute_batch <<-SQL
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
