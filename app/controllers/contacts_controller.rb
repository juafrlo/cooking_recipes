class ContactsController < ApplicationController
  def index
    if params[:contact].blank?
      @contact = Contact.new
    else
      @contact = Contact.new(params[:contact])
    end
    @page_description = t(:contact_description)
  end
  
  def create
    @contact = Contact.new(params[:contact])
    @errors = verify_recaptcha(@contact) && @contact.save ? false : true
  end  
end
