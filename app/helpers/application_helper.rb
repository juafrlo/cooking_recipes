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
    unless flash.blank?
      flash_class = flash[:error].blank? ? 'message-ok' : 'message-error'
      html = "<div class='#{flash_class}'>"
      html += "<div class='flash_text'>"
      html += flash[:notice] || flash[:error]
      html += "</div>"
      html += "<div class='close_flash'>"
      html += "<a href='#' onclick=\"$$('div.flash_message')[0].fade();return false\">x</a>"
      html += "</div>"
      html += "</div>"
      html
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
    html +=  "<span class='dateblock_mon'>#{l(date, :format => 'month')}</span>"
    html +=  "<span class='dateblock_day'>#{l(date, :format => 'day')}</span>"
    html +=  "<span class='dateblock_year'>#{l(date, :format => 'year')}</span>"
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
    controller_name == "recetas" && action_name == 'show' || 
    controller_name == "restaurants" && action_name == 'show' ||
    controller_name == "users" && action_name == 'new' ||
    controller_name == "users" && action_name == 'create'
  end
end