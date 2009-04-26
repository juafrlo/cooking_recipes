module RatingsHelper
  def num_votes(count_v)
    if count_v == 1
      count_v.to_s + ' voto'
    else
      count_v.to_s + ' votos'
    end
  end
end
