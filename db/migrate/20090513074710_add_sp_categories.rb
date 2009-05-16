class AddSpCategories < ActiveRecord::Migration
  def self.up
    Category.create(:name => 'Entrantes')
    Category.create(:name => 'Plato principal')
    Category.create(:name => 'Postres')    
  end

  def self.down
  end
end
