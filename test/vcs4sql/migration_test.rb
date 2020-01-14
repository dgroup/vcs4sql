require "test_helper"

class Vcs4sqlTest < ActiveSupport::TestCase

  test "gem has version" do
    refute_nil ::Vcs4sql::VERSION
  end
end
