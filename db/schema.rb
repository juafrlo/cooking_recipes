# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091029193033) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "categoryphoto_file_name"
    t.string   "categoryphoto_content_type"
    t.integer  "categoryphoto_file_size"
    t.datetime "categoryphoto_updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50,   :default => ""
    t.string   "comment",          :limit => 2000, :default => ""
    t.datetime "created_at",                                       :null => false
    t.integer  "commentable_id",                   :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15,   :default => "", :null => false
    t.integer  "user_id",                          :default => 0,  :null => false
    t.integer  "recipient_id",                     :default => 0,  :null => false
  end

  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "forum_cat_l1s", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_cat_l2s", :force => true do |t|
    t.integer  "forum_cat_l1_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_post_id"
    t.text     "description"
  end

  create_table "forum_posts", :force => true do |t|
    t.integer  "forum_cat_l2_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_replies", :force => true do |t|
    t.integer  "forum_post_id"
    t.integer  "user_id"
    t.text     "reply"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     :default => "pending"
    t.boolean  "initiator",  :default => false
  end

  create_table "ingredients", :force => true do |t|
    t.integer  "receta_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "noticias", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "intro"
    t.text     "content"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rating",                      :default => 0
    t.datetime "created_at",                                  :null => false
    t.string   "rateable_type", :limit => 15, :default => "", :null => false
    t.integer  "rateable_id",                 :default => 0,  :null => false
    t.integer  "user_id",                     :default => 0,  :null => false
  end

  add_index "ratings", ["user_id"], :name => "fk_ratings_user"

  create_table "recetas", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "country"
    t.string   "town"
    t.integer  "duration"
    t.integer  "people_can_eat"
  end

  create_table "rest_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "restcategoryphoto_file_name"
    t.string   "restcategoryphoto_content_type"
    t.integer  "restcategoryphoto_file_size"
    t.datetime "restcategoryphoto_updated_at"
  end

  create_table "restaurants", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "country"
    t.string   "town"
    t.text     "google_maps_code"
    t.text     "description"
    t.float    "creator_rating"
    t.integer  "avg_price"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "rest_category_id"
    t.string   "original_country"
  end

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "steps", :force => true do |t|
    t.integer  "receta_id"
    t.text     "explanation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                      :limit => 40
    t.string   "name",                       :limit => 100, :default => ""
    t.string   "email",                      :limit => 100
    t.string   "crypted_password",           :limit => 40
    t.string   "salt",                       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",             :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",            :limit => 40
    t.datetime "activated_at"
    t.integer  "number_of_posts",                           :default => 0
    t.string   "country"
    t.string   "town"
    t.string   "surname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "receive_comments_emails",                   :default => false
    t.boolean  "receive_friends_emails",                    :default => false
    t.boolean  "receive_friendships_emails"
    t.boolean  "receive_messages_emails"
    t.float    "recetas_avg",                               :default => 0.0
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
