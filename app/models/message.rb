class Message < ActiveRecord::Base

  is_private_message
  attr_accessor :to
  
end