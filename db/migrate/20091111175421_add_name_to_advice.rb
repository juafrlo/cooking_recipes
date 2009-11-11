class AddNameToAdvice < ActiveRecord::Migration
  def self.up
    remove_column :advices, :title
    add_column :advices, :name, :string
  end

  def self.down
    remove_column :advices, :name
    add_column :advices, :title, :string
  end
end
