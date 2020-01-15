# frozen_string_literal: true

# The database schema migration
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
module Vcs4sql
  module Sqlite
    # The applied (existing) database change log.
    class Applied
      # @param [Object] conn the connection to the database.
      # @param [String (frozen)] sql the query to fetch the change log from db.
      def initialize(conn, sql: "select * from changelog order by version")
        @conn = conn
        @sql = sql
      end

      def empty?
        changelog.empty?
      end

      # Ensure that applied change set has a change with particular version
      def absent(version)
        change(version).nil?
      end

      # Returns the details about applied change by version
      # @param [Object] version the version of applied change
      # @todo #/DEV Add verification of array usage over index.
      #  The changelog shouldn't be a null.
      def change(version)
        changelog[version]
      end

      private

      # Evaluate the applied database change log.
      # @todo #/DEV Add verification that connection not a null, throw error
      #  with proper error code in order to explain the problem.
      #  Potentially we need to define the class with error codes.
      def changelog
        return @changelog if defined? @changelog

        @changelog = @conn.query(@sql).map do |row|
          Changelog.new(
            row["file"], row["applied"], row["version"], row["md5sum"],
            row["sql"], id: row["id"]
          )
        end
      end
    end
  end
end
