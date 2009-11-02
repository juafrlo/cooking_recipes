class AddAdvicesAvgToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :advices_avg, :float
  end

  def self.down
    remove_column :users, :advices_avg
  end
end
