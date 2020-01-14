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
        ext = testdata ? "*.testdata.sql" : "*.sql"
        @changelog = Dir.glob("#{home}/#{ext}")
                        .select { |f| File.file? f }
                        .sort
                        .each_with_index.map do |f, i|
          sql = File.read(f).to_s.tr "\r", " "
          md5 = Digest::MD5.hexdigest sql
          Changelog.new(f, Time.now.iso8601(6), i, md5, sql)
        end
      end

      def each_with_index
        @changelog.each_with_index { |c, i| yield c, i }
      end

      def apply_all(conn)
        apply(-1, conn)
      end

      def apply(version, conn)
        # @todo #/DEV Raise an exception in case if any of arguments are null or
        #  empty. Potentially we may add verification of the type, but this is
        #  optional.
        @changelog.select { |change| change.version > version }.each do |change|
          change.apply(conn)
        end
      end
    end
  end
end
