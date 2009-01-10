class AddSpecificRoles < ActiveRecord::Migration
  def self.up
    Role.create(:title =>"admin")
    Role.create(:title =>"registered_user")
    Role.create(:title =>"visitor")
  end

  def self.down
  end
end
