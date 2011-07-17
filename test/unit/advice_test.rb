require 'test_helper'

class AdviceTest < ActiveSupport::TestCase
    
  test "search" do
    assert_equal Advice.search({:name => 'arroz'}), [advices(:one)]
    assert_equal Advice.search(:description => 'hervir'), [advices(:two)]
    assert_equal Advice.search(:name => 'arroz', :description => 'cocer'), 
      [advices(:one)]
    assert_equal Advice.search({:name => 'arroz'}, "olor"), [advices(:one)]
  end
  
end
