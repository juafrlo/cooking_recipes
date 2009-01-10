class ForumReply < ActiveRecord::Base
  belongs_to :forum_post
end
