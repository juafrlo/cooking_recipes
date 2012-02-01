# encoding: UTF-8
# Methods added to this helper will be available to all templates in the application. 
module ApplicationHelper
  include TagsHelper
  
  def homepage?
    controller_name == 'noticias' && action_name == 'index'
  end
  
  def main_index?
    (controller_name == 'recetas' || controller_name == 'advices' || controller_name == 'restaurants') && action_name == 'index'
  end
  
  def title(page_title)
    content_for(:title) {page_title}
  end
  
  def only_admin(text,link_path, separator = nil)
    html = ""
    if logged_in?  
      restrict_to "admin & !registered_user" do
        html = "#{separator} " if separator 
        html += link_to text, link_path
      end 
    end
  end

  def log_in_out()
    if !logged_in?
      link_to 'Login',  '/login' 
    else 
      link_to 'Logout',  '/logout'
    end 
  end

  def hello_user(user)
    if logged_in?
      '<span>Hola, '+user.login + '</span> | '
    end
  end

  def user_unread_messages
    "(#{current_user.unread_message_count})" if current_user.unread_message_count > 0
  end

  def my_flash_message(flash)
    begin
      unless flash.blank?
        flash_class = flash[:error].blank? ? 'message-ok' : 'message-error'
        html = "<div class='#{flash_class}'>"
        html += "<div class='flash_text'>"
        html += flash[:notice] || flash[:error] rescue ''
        html += "</div>"
        html += "<div class='close_flash'>"
        html += "<a href='#' onclick=\"$$('div.flash_message')[0].fade();return false\">x</a>"
        html += "</div>"
        html += "</div>"
        html
      end
    rescue
      ''
    end
  end

  def form_template_button(f)
    if action_name == 'new'
      f.submit t(:Publish)
    else
      f.submit t(:Update)
    end 
  end

  def draw_image(image, desc = nil)
    if image.split('/').last == "missing.png"
      image_tag 'others/no_photo.jpg', :alt => t(:no_photo)
    else
      image_tag image, :alt => desc
    end
  end

  def no_forums
    !["forum_cat_l2s","forum_posts", "forum_replies"].include?(controller_name)
  end

  def can_edit(item)
    current_user && (item.user == current_user || current_user.admin?) 
  end

  def invitations_number
    "(#{current_user.received_invitations.size})" if current_user.received_invitations.size > 0
  end

  def date_block(date)
    html = "<div class='dateblock'>"
    html +=  "<span class='dateblock_mon'>#{l(date, :format => :month)} </span>"
    html +=  "<span class='dateblock_day'>#{l(date, :format => :day)} </span>"
    html +=  "<span class='dateblock_year'>#{l(date, :format => :year)}</span>"
    html += "</div>"
    html
  end

  def number_of_comments(obj)
    "<span class='number_comments'>(#{obj.comments.size} #{t(:comments)})</span>"
  end

  def number_of_recipes(number)
    number > 1 ? "#{number} #{t(:recetas)}" : "#{number} #{t(:receta)}"
  end
  
  def uses_redbox
    receta_page? || 
    restaurant_page? ||
    controller_name == "users" && action_name == 'new' ||
    controller_name == "users" && action_name == 'create'
  end
    
  def page_description
    @page_description.blank? ? DESCRIPTION: @page_description
  end
  
  def home_page?
    controller_name == "noticias" && action_name == 'index'
  end
  
  def receta_page?
    controller_name == "recetas" && action_name == 'show'
  end
  
  def advice_page?
    controller_name == "advices" && action_name == 'show'
  end
  
  def restaurant_page?
    controller_name == "restaurants" && action_name == 'show'
  end
  
  def social_page?
    receta_page? || advice_page? || restaurant_page?
  end
  
  def meta_robots_tags
    "<meta content='noindex,follow' name='robots' />" unless @meta_no_index_follow.blank?
  end
  
  def twitter_message
    title_element = @advice || @receta || @restaurant
    if title_element.present?
      title_element.name.gsub(' ', '%20')
    end
  end
  
  
  # Patched error_messages_for to fix encoding error
  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys
    
    if object = options.delete(:object)
      objects = Array.wrap(object)
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end
    
    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      options[:object_name] ||= params.first
    
      I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
        header_message = if options.include?(:header_message)
          options[:header_message]
        else
          object_name = options[:object_name].to_s
          object_name = I18n.t(object_name, :default => object_name.gsub('_', ' '), :scope => [:activerecord, :models], :count => 1)
          locale.t :header, :count => count, :model => object_name
        end
        message = options.include?(:message) ? options[:message] : locale.t(:body)

        error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg)}}.join.html_safe
 
      ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
      error_messages = ic.iconv(error_messages + ' ')[0..-2]
 
        contents = ''
        contents << content_tag(options[:header_tag] || :h2, header_message) unless header_message.blank?
        contents << content_tag(:p, message) unless message.blank?
        contents << content_tag(:ul, error_messages)
    
        content_tag(:div, contents.html_safe, html)
      end
    else
       ''
     end
  end
end