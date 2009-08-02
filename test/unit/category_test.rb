require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "should_delete_category_photo" do
    category = categories(:one)  
    prefix_route = Category::PREFIX_ROUTE
    category_route = prefix_route + category.id.to_s + "/original/"
    prepare_directories(category,prefix_route,category_route)
    assert FileTest.exists?(category_route + category.categoryphoto_file_name)
    category.delcategoryphoto(prefix_route)
    assert_equal FileTest.exists?(category_route + category.categoryphoto_file_name), false
    FileUtils.rm_rf(prefix_route + category.id.to_s) 
  end
  
  protected
  def prepare_directories(category,prefix_route,category_route)
    if File.directory?(prefix_route + category.id.to_s)
      FileUtils.rm_rf(prefix_route + category.id.to_s) 
    end
    if File.directory?(prefix_route + category.id.to_s)
      FileUtils.rm_rf(category_route) 
    end
    FileUtils.mkdir(prefix_route + category.id.to_s)   
    FileUtils.mkdir(category_route)    
    FileUtils.cp(prefix_route + category.categoryphoto_file_name,
     category_route)
  end
  
  
  
  
end
