class AddRecetasAvgToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :recetas_avg, :float, :default => 0.0
  end

  def self.down
    remove_column :users, :recetas_avg
  end
end
