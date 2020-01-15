# frozen_string_literal: true

# The expected database change log.
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
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

          if change.matches existing.change(i)
            version = i
          else
            change.alert existing.change(i)
          end
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
