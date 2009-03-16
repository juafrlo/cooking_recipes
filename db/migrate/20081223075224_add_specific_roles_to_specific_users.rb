class AddSpecificRolesToSpecificUsers < ActiveRecord::Migration
  def self.up
    @u1 = User.find(1);
    @u2 = User.find(2);
    #@u3 = User.find(3);
      
    @u1.roles << Role.find([1])
    @u2.roles << Role.find([2])
    #@u3.roles << Role.find([3])


  end

  def self.down
  end
end
20081223075223