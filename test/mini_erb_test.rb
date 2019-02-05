require_relative '../lib/mini_erb'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class MiniErbTest < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_has_a_version_number
    refute_nil ::MiniErb::VERSION
  end

end
