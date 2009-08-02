require 'test_helper'

class ForumCatL2Test < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
    
  test "last_post" do
    assert_equal forum_cat_l2s(:one).last_post, forum_posts(:one)
  end

end
