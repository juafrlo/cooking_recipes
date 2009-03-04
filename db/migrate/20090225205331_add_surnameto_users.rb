class AddSurnametoUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :surname, :string
  end

  def self.down
    add_column :users, :surname, :string
  end
end
