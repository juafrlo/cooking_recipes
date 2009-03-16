class AddSpUsers < ActiveRecord::Migration
  User.create(:name =>"Karlos",  :login =>"usuario2",
              :email =>"usuario2@gmail.com", :password =>"usuario2", :password_confirmation =>"usuario2")

  User.create(:name =>"Antonio",  :login =>"antonio",
                          :email =>"usuario4@gmail.com", :password =>"antonio", :password_confirmation =>"antonio")


end
