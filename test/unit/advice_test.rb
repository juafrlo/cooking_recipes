require 'test_helper'

class AdviceTest < ActiveSupport::TestCase
    
  test "search" do
    assert_equal Advice.search({:title => 'arroz'}), [advices(:one)]
    assert_equal Advice.search(:description => 'hervir'), [advices(:two)]
    assert_equal Advice.search(:title => 'arroz', :description => 'cocer'), 
      [advices(:one)]
    assert_equal Advice.search({:title => 'arroz'}, "olor"), []
  end
  
end
