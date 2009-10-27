class AddAttachmentsToRestCategories < ActiveRecord::Migration
  def self.up
    add_column :rest_categories, :restcategoryphoto_file_name, :string
    add_column :rest_categories, :restcategoryphoto_content_type, :string
    add_column :rest_categories, :restcategoryphoto_file_size, :integer
    add_column :rest_categories, :restcategoryphoto_updated_at, :datetime
  end

  def self.down
    remove_column :rest_categories, :restcategoryphoto_updated_at
    remove_column :rest_categories, :restcategoryphoto_file_size
    remove_column :rest_categories, :restcategoryphoto_content_type
    remove_column :rest_categories, :restcategoryphoto_file_name
  end
end
