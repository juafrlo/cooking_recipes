require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  test "rate" do
    last_rating = Rating.rating(Receta.find(2), "Receta")
    Rating.rate(recetas(:arroz_a_la_cubana).id,4,"Receta",User.last)
    assert_not_equal Rating.rating(Receta.find(2), "Receta"), last_rating
  end  

  test "number of votes" do 
    assert_equal Rating.number_of_votes("Receta",recetas(:arroz_a_la_cubana)), 2
    Rating.rate(recetas(:arroz_a_la_cubana).id,4,"Receta",User.last.id)
    assert_equal Rating.number_of_votes("Receta",recetas(:arroz_a_la_cubana)), 3
  end
  
  test "rating" do
    assert_equal Rating.rating(Receta.find(2), 'Receta'), 4.5
  end

  test "is_rated?" do
    assert_equal Rating.is_rated?(Receta.find(1),users(:quentin)), false
    Rating.rate(1,4,"Receta",users(:quentin))
    assert_equal Rating.is_rated?(Receta.find(1),users(:quentin)), true
  end

end
