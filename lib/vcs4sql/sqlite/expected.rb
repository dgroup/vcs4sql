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

require_relative "../exception"

module Vcs4sql
  module Sqlite
    # The expected database change log.
    # Contains all changes which should be applied to target database.
    class Expected
      def initialize(home, testdata)
        @home = home
        @nonprod = ->(f) { !testdata && (f.to_s.end_with? ".testdata.sql") }
      end

      # Apply all sql files one by one
      # @param [Object] conn the connection to the database.
      def apply_all(conn)
        apply(-1, conn)
      end

      # Apply sql files which weren't applied yet
      # @param [Object] conn the connection to the database.
      def apply_mismatch(existing, conn)
        version = -1
        changelog.each_with_index do |change, i|
          break if existing.absent(i)

          unless change.matches existing.change(i)
            raise Vcs4sql::ChecksumMismatchError.new change, existing.change(i)
          end

          version = i
        end
        apply(version, conn)
      end

      private

      # Apply sql files which weren't applied yet based on version
      # @param [Integer] ver The latest applied version to the database
      # @param [Object] conn the connection to the database.
      def apply(ver, conn)
        # @todo #/DEV Raise an exception in case if any of arguments are null or
        #  empty. Potentially we may add verification of the type, but this is
        #  optional.
        changelog.select { |change| change.version > ver }.each do |change|
          change.apply(conn)
        end
      end

      def changelog
        return @changelog if defined? @changelog

        @changelog = Dir.glob("#{@home}/*.sql")
                        .select { |f| File.file? f }
                        .reject(&@nonprod)
                        .sort
                        .each_with_index.map do |f, i|
          sql = File.read(f).to_s.tr "\r", " "
          md5 = Digest::MD5.hexdigest sql
          Changelog.new(f, Time.now.iso8601(6), i, md5, sql)
        end
      end
    end
  end
end
