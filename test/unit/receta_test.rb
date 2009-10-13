require 'test_helper'

class RecetaTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  def test_search_with_ingr_without_duration
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("",
     [ingredients(:arroz),ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, [recetas(:paella)]
    assert_equal recetas_no_exact, [recetas(:arroz_a_la_cubana)]
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("",
     [ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, [recetas(:paella)]
    assert_equal recetas_no_exact, []
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("", [])
    assert_equal recetas_exact, []
    assert_equal recetas_no_exact, []
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("", [ingredients(:arroz)])
    assert_equal recetas_exact, [recetas(:paella), recetas(:arroz_a_la_cubana)]
    assert_equal recetas_no_exact, []
  end
  
  def test_serach_with_ingr_with_duration
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("20",
      [ingredients(:arroz),ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, []
    assert_equal recetas_no_exact, [recetas(:arroz_a_la_cubana)]
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("120",
      [ingredients(:arroz),ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, [recetas(:paella)]
    assert_equal recetas_no_exact, [recetas(:arroz_a_la_cubana)]
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("120",
      [ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, [recetas(:paella)]
    assert_equal recetas_no_exact, []
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("20",
      [ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, []
    assert_equal recetas_no_exact, []
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("20", [])
    assert_equal recetas_exact, [recetas(:arroz_a_la_cubana)]
    assert_equal recetas_no_exact, []
    recetas_exact, recetas_no_exact = Receta.search_with_ingr("twenty", 
      [ingredients(:arroz),ingredients(:pollo), ingredients(:agua)])
    assert_equal recetas_exact, []
    assert_equal recetas_no_exact, []
  end
  
  def test_search
    assert_equal Receta.search(recetas(:paella).name, "", "", ""),
      [recetas(:paella)]
    assert_equal Receta.search("", "2", "", ""),
      [recetas(:arroz_a_la_cubana)]
    assert_equal Receta.search("", "", "Cuba", ""),
      [recetas(:arroz_a_la_cubana)]
    assert_equal Receta.search("", "", "", "Valencia"),
      [recetas(:paella)]
    assert_equal Receta.search("", "", "Spain", "Alicante"), []
  end
  
  def test_find_ordered
    assert_equal Receta.find_ordered(User.find(1), {:order => "name" + ' ASC'}),
      [recetas(:arroz_a_la_cubana), recetas(:paella)]
    assert_equal Receta.find_ordered(User.find(1), {:order => "name" + ' DESC'}),
      [recetas(:paella), recetas(:arroz_a_la_cubana)]
    assert_equal Receta.find_ordered(User.find(1), {:order => "category_id" + ' ASC'}),
      [recetas(:paella), recetas(:arroz_a_la_cubana)]
    assert_equal Receta.find_ordered(User.find(1), {:order => "category_id" + ' DESC'}),
      [recetas(:arroz_a_la_cubana), recetas(:paella)]
    assert_equal Receta.find_ordered(User.find(1), {:order => "puntuation" + ' ASC'}),
      [recetas(:arroz_a_la_cubana), recetas(:paella)]
    assert_equal Receta.find_ordered(User.find(1), {:order => "puntuation" + ' DESC'}),
      [recetas(:paella), recetas(:arroz_a_la_cubana)]
  end
  
  def test_search
    assert_equal Receta.search('paella',nil,nil,nil), [recetas(:paella)]
    assert_equal Receta.search(nil,"1",nil,nil), [recetas(:paella)]
    assert_equal Receta.search(nil,nil,'Spain',nil), [recetas(:paella)]
    assert_equal Receta.search(nil,nil,nil,'Valencia'), [recetas(:paella)]
    assert_equal Receta.search(nil,nil,'Spain','Valencia'), [recetas(:paella)]  
    assert_equal Receta.search('paella','1','Spain','Valencia'), [recetas(:paella)]  
    assert_equal Receta.search('arroz','1','Spain','Valencia'), []  
    assert_equal Receta.search('arroz','2','Cuba',nil), [recetas(:arroz_a_la_cubana)]  
    assert_equal Receta.search('arroz','2',nil,nil), [recetas(:arroz_a_la_cubana)]  
  end
  
  def test_send_notification_to_friends
    assert_difference 'ActionMailer::Base.deliveries.size' do
      Receta.create(:name => 'A name', :description => 'A descr', :duration => 2,
        :user_id => users(:quentin))      
    end
  end
  
end
