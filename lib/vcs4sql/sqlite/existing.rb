# frozen_string_literal: true

# The database schema migration
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
module Vcs4sql

  class Existing

    def initialize(conn)
      @conn = conn
      @changes = "select /* ll.sqlid:#{__FILE__}:#{__method__} */ * from changelog"
      @changelog = @conn.query(@changes).map do |row|
        Changelog.new(row["file'], row['applied'], row['version'], row['md5']) }
      end
    end

    def each
      @changelog.each { |c| yield c }
    end

    private:

  end
end