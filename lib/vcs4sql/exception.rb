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

module Vcs4sql
  class Vcs4sqlError < StandardError
    attr_reader :code

    def initialize(code, msg)
      super("#{code}: #{msg}")
      @code = code
    end
  end

  class ChecksumMismatchError < Vcs4sqlError
    def initialize(expected, applied)
      msg = <<~MSG
        Version '#{expected.version}' has checksum mismatch.

        The possible root cause is that the file with migration, which was applied already, got changed recently.
        As a workaround, you may change the md5sum in the database in case if these changes are minor
        and don't affect the structure:
        update changelog set md5sum='#{expected.md5sum}' where id=#{applied.id}

        In case if changes are major and affect the database structure then they should be reverted
        and introduce it as a new change.

        Expected '#{expected.version}' version from '#{expected.file}' (#{expected.md5sum}) has SQL:
        #{expected.sql}
        .............................................................................................
        Existing '#{applied.version}' version from '#{applied.file}' (#{applied.md5sum}) has SQL:
        #{applied.sql}
        .............................................................................................
      MSG
      super("vcs4sql-001", msg)
    end
  end
end
