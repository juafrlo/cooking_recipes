require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "rate" do
    Rating.rate(recetas(:arroz_a_la_cubana).id,4,"Receta",users(:quentin))
    assert_equal Rating.rating(Receta.find(2), "Receta"), 4
  end  

  test "number of votes" do 
    assert_equal Rating.number_of_votes("Receta",recetas(:arroz_a_la_cubana)), 1
    Rating.rate(2,4,"Receta",users(:quentin))
    assert_equal Rating.number_of_votes("Receta",recetas(:arroz_a_la_cubana)), 2
  end
  
  test "rating" do
    assert_equal Rating.rating(Receta.find(2), 'Receta'), 4.0
    Rating.rate(2,1,"Receta",users(:quentin))
    assert_equal Rating.rating(Receta.find(2), 'Receta'), 2.5
  end

  test "is_rated?" do
    assert_equal Rating.is_rated?(Receta.find(1),users(:quentin)), false
    Rating.rate(1,4,"Receta",users(:quentin))
    assert_equal Rating.is_rated?(Receta.find(1),users(:quentin)), true
  end

end
