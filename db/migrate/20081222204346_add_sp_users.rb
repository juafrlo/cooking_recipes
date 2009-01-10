class AddSpUsers < ActiveRecord::Migration
  def self.up
    @u1 = User.create(:first_name =>"John", :last_name =>"Smith", :login =>"admin",
                :email =>"misrecetas1@gmail.com", :password =>"admin", :password_confirmation =>"admin")

    
    @u2 = User.create(:first_name =>"Terry", :last_name =>"Bogard", :login =>"registered_user",
                :email =>"misrecetas2@gmail.com", :password =>"registered_user", :password_confirmation =>"registered_user")

    @u3 = User.create(:first_name =>"Andrew", :last_name =>"Park", :login =>"visitor",
                :email =>"misrecetas3@gmail.com", :password =>"visitor", :password_confirmation =>"visitor")


  end

  def self.down
  end
end
