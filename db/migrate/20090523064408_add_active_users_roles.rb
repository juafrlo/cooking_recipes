class AddActiveUsersRoles < ActiveRecord::Migration
  def self.up
    u1 = User.find_by_login('terry_wolf')
    u1.activated_at = u1.created_at
    u1.roles << Role.find([1])
    u1.save!
    u2 = User.find_by_login('Charlie')
    u2.activated_at = u2.created_at
    u2.roles << Role.find([2])
    u2.save!
  end

  def self.down
  end
end
