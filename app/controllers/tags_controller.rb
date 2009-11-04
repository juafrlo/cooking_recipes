class TagsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => 'auto_complete_for_tag_name'

  def auto_complete_for_tag_name
    @tags = Tag.find(:all, :conditions => [ 'LOWER(name) LIKE ?', '%' + (params[:id] || params[:tag_list]) + '%' ])
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end
end
