require_relative "../sqlite_test"

class VersionTest < ActiveSupport::TestCase
  test "gem has version" do
    refute_nil ::Vcs4sql::VERSION
  end
end
