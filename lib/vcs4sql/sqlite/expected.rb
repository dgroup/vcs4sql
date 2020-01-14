# frozen_string_literal: true

# The expected database change log.
#
# Author:: Yurii Dubinka (yurii.dubinka@gmail.com)
# Copyright:: Copyright (c) 2019-2020 Yurii Dubinka
# License:: MIT
module Vcs4sql
  # The expected database change log.
  # Contains all changes which should be applied to target database.
  class Expected
    def initialize(home = '../upgrades/sqlite', testdata = false)
      @home = home
      @ext = testdata ? '*.testdata.sql' : '*.sql'
      @changelog = Dir.glob("#{@home}/#{@ext}").select { |f| File.file? f }.each_with_index.map do |f, i|
        sql = File.read(f).to_s.gsub "\r", ''
        md5 = Digest::MD5.hexdigest sql
        Changelog.new(f, Time.now.iso8601(6), i, md5, sql)
      end
    end

    def each
      @changelog.each { |c| yield c }
    end

    def each_with_index
      @changelog.each_with_index { |c, i| yield c, i }
    end
  end
end
