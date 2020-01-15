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
