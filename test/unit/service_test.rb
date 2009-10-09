require File.dirname(__FILE__) + '/../test_helper'

class ServiceTest < Test::Unit::TestCase
  def test_most_frequent
    assert_equal 'code', Service.most_frequent.name
  end
end
