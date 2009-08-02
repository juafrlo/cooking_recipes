class AdminsController < ApplicationController
  
  before_filter :admin_required

  def index
  end

end