require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "search" do
    assert_equal Restaurant.search({:name => 'Pepe'}), [restaurants(:one)]
    assert_equal Restaurant.search({:rest_category_id => 1}), [restaurants(:one)]
    assert_equal Restaurant.search({:country => 'Spain'}), [restaurants(:one)]
    assert_equal Restaurant.search({:town => 'Milan'}), [restaurants(:two)]
    assert_equal Restaurant.search({:description => 'warm'}), [restaurants(:two)]
    assert_equal Restaurant.search({:creator_rating => '4'}), [restaurants(:two)]
    assert_equal Restaurant.search({:avg_price => '15'}), [restaurants(:one)]
    assert_equal Restaurant.search({:name => 'Pepe', :country => 'Spain'}), [restaurants(:one)]
  end
  
  test "top" do
    assert_equal Restaurant.top,
     [restaurants(:two), restaurants(:one)]
  end
  
  test "last_voted" do
    assert_equal Restaurant.last_voted,
    [restaurants(:two)]    
  end
end
