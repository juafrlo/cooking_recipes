class ContactsController < ApplicationController
  def index
    if params[:contact].blank?
      @contact = Contact.new
    else
      @contact = Contact.new(params[:contact])
    end
  end
  
  def create
    @contact = Contact.new(params[:contact])
    @contact.save
  end
  
end
