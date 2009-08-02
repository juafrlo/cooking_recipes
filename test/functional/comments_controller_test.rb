require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  test 'should create comment' do
    login_as :quentin
     assert_difference('Comment.count') do
       create_comment
     end
  end
  
  test 'should not create comment' do
     assert_no_difference('Comment.count') do
       create_comment
     end
  end

  test 'should destroy comment' do
    login_as :quentin
    assert_difference('Comment.count', -1) do
      delete :destroy, :id => Comment.last.id
    end
  end
  
  test 'should not destroy comment' do
    login_as :aaron
    assert_no_difference('Comment.count') do
      delete :destroy, :id => Comment.last.id
    end
  end

  
  private
  def create_comment
    post :create,
       :comment => {:comment => 'Some comment'}, 
       :commentable_id => 1,
       :commentable_type => "receta",
       :user_id => users(:quentin).id,
       :recipient => 2
  end
  

  
end

