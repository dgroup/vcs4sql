# frozen_string_literal: true

require "securerandom"
require "digest"
require_relative "changelog"
require_relative "expected"

# The database schema migration
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
module Vcs4sql::Sqlite
  class Migration

    def initialize(file)
      @conn = SQLite3::Database.new file
      @conn.results_as_hash = true
    end

    def upgrade(home: "../upgrades/sqlite", testdata: false, ext: testdata ? "*.testdata.sql" : "*.sql")
      # @todo #/DEV Lock the upgrade procedure in order to avoid the cases when multiple processes are going
      #  to modify/upgrade the same database schema. No concurrent upgrade is allowed so far.
      install_vcs4sql
      existing = @conn.query("select /* ll.sqlid:#{__FILE__}:#{__method__} */ * from changelog").map do |row|
        Changelog.new(
            row["file"],
            row["applied"],
            row["version"],
            row["md5sum"],
            row["sql"],
            id: row["id"]
        )
      end
      expected = Dir.glob("#{home}/#{ext}").select { |f| File.file? f }.each_with_index.map do |f, i|
        sql = File.read(f).to_s.gsub "\r", ""
        md5 = Digest::MD5.hexdigest sql
        Changelog.new(f, Time.now.iso8601(6), i, md5, sql)
      end
      if existing.empty?
        expected.each { |change| change.apply(@conn) }
      else
        version = -1
        expected.each_with_index do |change, i|
          if !existing[i].nil?
            if change.md5sum == existing[i].md5sum
              version = i
            else
              raise <<-MSG
vcs4sql-001: Version '#{change.version}' has checksum mismatch.
                
The possible root cause is that the file with migration, which was applied already, got changed recently.
As a workaround, you may change the md5sum in the database in case if these changes are minor 
and don't affect the structure:
update changelog set md5sum='#{change.md5sum}' where id=#{existing[i].id}

In case if changes are major and affect the database structure then they should be reverted 
and introduce it as a new change. 

Expected '#{change.version}' version from '#{change.file}' (#{change.md5sum}) has SQL:
#{change.sql}
.............................................................................................
Existing '#{existing[i].version}' version from '#{existing[i].file}' (#{existing[i].md5sum}) has SQL:
#{existing[i].sql}
.............................................................................................
              MSG
            end
          else
            break
          end
        end
        expected.select { |change| change.version > version }.each do |change|
          change.apply(@conn)
        end
      end
    end

    private

    def install_vcs4sql
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