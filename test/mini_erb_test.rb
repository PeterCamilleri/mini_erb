require_relative '../lib/mini_erb'
gem              'minitest'
require          'minitest/autorun'
require          'minitest_visible'

class MiniErbTest < Minitest::Test

  #Track mini-test progress.
  include MinitestVisible

  def test_that_it_has_a_version_number
    refute_nil ::MiniErb::VERSION
    assert(::MiniErb::VERSION.frozen?)
    assert(::MiniErb::VERSION.is_a?(String))
    assert(/\A\d+\.\d+\.\d+/ =~ ::MiniErb::VERSION)
  end

  def test_that_it_has_a_description
    refute_nil ::MiniErb::DESCRIPTION
    assert(::MiniErb::DESCRIPTION.frozen?)
    assert(::MiniErb::DESCRIPTION.is_a?(String))
  end

  def test_the_essentials
    assert_equal(MiniErb, MiniErb.new("Test 1 2 3").class)

  end
end
