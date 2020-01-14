# frozen_string_literal: true

# The database schema migration
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
module Vcs4sql
  module Sqlite
    class Existing
      def initialize(conn, sql: "select * from changelog order by version")
        @changelog = conn.query(sql).map do |row|
          Changelog.new(
            row["file"],
            row["applied"],
            row["version"],
            row["md5sum"],
            row["sql"],
            id: row["id"]
          )
        end
      end

      def empty?
        @changelog.empty?
      end

      def absent(index)
        change(index).nil?
      end

      # @todo #/DEV Add verification of array usage over index.
      #  The changelog shouldn't be a null.
      def change(index)
        @changelog[index]
      end
    end
  end
end
