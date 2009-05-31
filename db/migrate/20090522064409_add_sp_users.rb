class AddSpUsers < ActiveRecord::Migration
  def self.up
    User.create(:login => 'terry_wolf', :password => 'terry_wolf',
     :password_confirmation => 'terry_wolf', :email => 'juafrlo@gmail.com').save!
     User.create(:login => 'charlie', :password => 'charlie',
      :password_confirmation => 'charlie', :email => 'misrecetas_charlie@gmail.com').save!
  end

  def self.down
    User.find_by_login('terry_wolf').destroy    
    User.find_by_login('charlie').destroy
  end
end
