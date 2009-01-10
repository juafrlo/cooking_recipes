class AddUserRoles < ActiveRecord::Migration
  def self.up
    create_table "roles_users", :id => false, :force => true do |t|
       t.column "role_id", :integer
       t.column "user_id", :integer
    end
  end

  def self.down
  end
end
