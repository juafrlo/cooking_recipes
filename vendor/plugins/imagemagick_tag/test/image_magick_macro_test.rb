require 'test/unit'

begin
  require "RMagick"
  
  class ImageMagickTest < Test::Unit::TestCase
    class SquareTestRecipe
      def self.execute_recipe_on(image, size)
        # non-destructive method, to test the return-image process
        image.resize(size.to_i, size.to_i)
      end
    end
    
    class ImageMagickTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick"),
                      :cache=>"/tmp/imagemagick_cache"
      
      imagemagick_recipe :string_ten_pixels, "resize(10!x10!)"
      imagemagick_recipe :proc_one_pixel, Proc.new {|image| image.resize!(1,1) }
      imagemagick_recipe :method_square, :method_square
      imagemagick_recipe :class_square, SquareTestRecipe
      
     private
      def method_square(image, size)
        image.resize!(size.to_i, size.to_i)
      end
    end
    
    class ImageMagickSubdirTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures")
    end
    
    class ImageMagickCustomNameTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick"),
                      :action_name=>"customaction"
    end
    
    class ImageMagickLocalRecipesTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick")
      
      before_filter :add_local_recipes, :only=>:imagemagick
      
      def wrapper_method
        add_local_recipes
        imagemagick
      end
      
     private
      def method_square(image, size)
        image.resize!(size.to_i, size.to_i)
      end
      
      def add_local_recipes
        imagemagick_local_recipes.add { |recipes|
          recipes.add :local_string_ten_pixels, "resize(10!x10!)"
          recipes.add :local_proc_one_pixel, Proc.new {|image| image.resize!(1,1) }
          recipes.add :local_method_square, :method_square
          recipes.add :local_class_square, SquareTestRecipe
        }
      end
    end
    
    class ImageMagickLocalRecipesOnlyTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick"),
                      :max_recipe_level=>:local
      imagemagick_recipe :local_string_ten_pixels, "resize(10!x10!)"
    end
    
    class ImageMagickGlobalAndLocalRecipesOnlyTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick"),
                      :max_recipe_level=>:global
      imagemagick_recipe :local_string_ten_pixels, "resize(10!x10!)"
    end
    
    class ImageMagickAsFilterTestController < ActionController::Base
      imagemagick_filter_for :picture
      
      def picture
        if @params[:id]=="existing_image"
          render :file=>File.dirname(__FILE__) + "/../fixtures/imagemagick/presentation.jpg"
        else
          render :text=>@params[:id]
        end
      end
    end
    
    def setup
      @controller = ImageMagickTestController.new
  
      # enable a logger so that (e.g.) the benchmarking stuff runs, so we can get
      # a more accurate simulation of what happens in "real life".
      @controller.logger = Logger.new(nil)
  
      @request    = ActionController::TestRequest.new
      @response   = ActionController::TestResponse.new
      
      FileUtils.mkdir("/tmp/imagemagick_cache")
    end
    
    def teardown
      FileUtils.rm_rf("/tmp/imagemagick_cache")
    end
  
    def test_no_resize
      get :imagemagick, :id=>"presentation.jpg"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_invalid_filename
      get :imagemagick, :id=>"notfound.jpg"
      assert_response :missing
    end
    
    def test_resize_blur
      get :imagemagick, :id=>"presentation.jpg", :commands=>"s(100x100)+blur(0,1)"
      assert_image_with_dimensions 100
    end
    
    def test_crop_colorize
      get :imagemagick, :id=>"presentation.jpg", :commands=>"crop(10,20,40,50)+colorize(0.3,0.3,0.3,dddddd)"
      assert_image_with_dimensions 40, 50
    end
    
    def test_equalize_flip_flop
      get :imagemagick, :id=>"presentation.jpg", :commands=>"equalize+flip+flop"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_implode_level_normalize
      get :imagemagick, :id=>"presentation.jpg", :commands=>"implode(0.8)+level(0,1.50)+normalize"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_oilpaint_opaque_posterize
      get :imagemagick, :id=>"presentation.jpg", :commands=>"oilpaint(3.0)+opaque(fff,f00)+posterize(4)"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_sharpen_rotate_border
      get :imagemagick, :id=>"presentation.jpg", :commands=>"sharpen(0.3,0.1)+border(2,2,f00)+rotate(-45)"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_trim
      get :imagemagick, :id=>"presentation.jpg", :commands=>"trim"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_part
      get :imagemagick, :id=>"presentation.jpg", :commands=>"part(100x100)"
      assert_image_with_dimensions 100, 100
    end
    
    def test_cache
      get :imagemagick, :id=>"presentation.jpg", :commands=>"equalize+flip+flop"
      assert_equal "image/jpeg", @response.headers["Content-type"]
      
      assert File.exists?("/tmp/imagemagick_cache/ImageMagickTestImageMagickTestController.equalize.flip.flop.presentation.jpg")
      
      get :imagemagick, :id=>"presentation.jpg", :commands=>"equalize+flip+flop"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_subdirectory
      # tests image-filename-with-path
      @controller = ImageMagickSubdirTestController.new
      
      get :imagemagick, :id=>"imagemagick/presentation.jpg"
      assert_equal "image/jpeg", @response.headers["Content-type"]
      
      get :imagemagick, :id=>"/imagemagick/presentation.jpg"
      assert_equal "image/jpeg", @response.headers["Content-type"]
      
      get :imagemagick, :id=>"../../imagemagick/presentation.jpg"
      assert_response :missing
    end
    
    def test_recipe_string
      get :imagemagick, :id=>"presentation.jpg", :commands=>"string_ten_pixels"
      assert_image_with_dimensions 10, 10
    end
    
    def test_recipe_proc
      get :imagemagick, :id=>"presentation.jpg", :commands=>"proc_one_pixel"
      assert_image_with_dimensions 1, 1
    end
    
    def test_recipe_method
      get :imagemagick, :id=>"presentation.jpg", :commands=>"method_square(8)"
      assert_image_with_dimensions 8, 8
    end
    
    def test_recipe_class
      get :imagemagick, :id=>"presentation.jpg", :commands=>"class_square(16)"
      assert_image_with_dimensions 16, 16
    end
    
    def test_custom_action_name
      @controller = ImageMagickCustomNameTestController.new
      get :customaction, :id=>"presentation.jpg"
      assert_equal "image/jpeg", @response.headers["Content-type"]
    end
    
    def test_global_recipes
      ActionController::Macros::ImageMagick::GlobalRecipes.add do |recipes|
        recipes.add :global_string_ten_pixels, "resize(10!x10!)"
        recipes.add :global_proc_one_pixel, Proc.new {|image| image.resize!(1,1) }
        recipes.add :global_class_square, SquareTestRecipe
      end
      
      # as a string
      get :imagemagick, :id=>"presentation.jpg", :commands=>"global_string_ten_pixels"
      assert_image_with_dimensions 10, 10
      
      # as a proc
      get :imagemagick, :id=>"presentation.jpg", :commands=>"global_proc_one_pixel"
      assert_image_with_dimensions 1, 1
      
      # as a class
      get :imagemagick, :id=>"presentation.jpg", :commands=>"global_class_square(16)"
      assert_image_with_dimensions 16, 16
      
      # for the next tests
      ActionController::Macros::ImageMagick::GlobalRecipes.clear
    end
    
    def test_local_recipes_with_wrapper_method
      @controller = ImageMagickLocalRecipesTestController.new
      
      # as a string
      get :wrapper_method, :id=>"presentation.jpg", :commands=>"local_string_ten_pixels"
      assert_image_with_dimensions 10, 10
      
      # as a proc
      get :wrapper_method, :id=>"presentation.jpg", :commands=>"local_proc_one_pixel"
      assert_image_with_dimensions 1, 1
      
      # as a method
      get :wrapper_method, :id=>"presentation.jpg", :commands=>"local_method_square(8)"
      assert_image_with_dimensions 8, 8
      
      # as a class
      get :wrapper_method, :id=>"presentation.jpg", :commands=>"local_class_square(16)"
      assert_image_with_dimensions 16, 16
    end
    
    def test_local_recipes_with_filter
      @controller = ImageMagickLocalRecipesTestController.new
      
      # as a string
      get :imagemagick, :id=>"presentation.jpg", :commands=>"local_string_ten_pixels"
      assert_image_with_dimensions 10, 10
      
      # as a proc
      get :imagemagick, :id=>"presentation.jpg", :commands=>"local_proc_one_pixel"
      assert_image_with_dimensions 1, 1
      
      # as a method
      get :imagemagick, :id=>"presentation.jpg", :commands=>"local_method_square(8)"
      assert_image_with_dimensions 8, 8
      
      # as a class
      get :imagemagick, :id=>"presentation.jpg", :commands=>"local_class_square(16)"
      assert_image_with_dimensions 16, 16
    end
    
    def test_local_recipes_only
      ActionController::Macros::ImageMagick::GlobalRecipes.add :global_string_ten_pixels, "resize(10!x10!)"
      
      @controller = ImageMagickLocalRecipesOnlyTestController.new
      
      # local recipe, is allowed
      get :imagemagick, :id=>"presentation.jpg", :commands=>"local_string_ten_pixels"
      assert_image_with_dimensions 10, 10
      
      # global recipe, is not allowed
      get :imagemagick, :id=>"presentation.jpg", :commands=>"global_string_ten_pixels"
      assert_response 500
      
      # builtin recipe, is not allowed
      get :imagemagick, :id=>"presentation.jpg", :commands=>"resize(10)"
      assert_response 500
      
      ActionController::Macros::ImageMagick::GlobalRecipes.clear
    end
    
    def test_global_and_local_recipes_only
      ActionController::Macros::ImageMagick::GlobalRecipes.add :global_string_ten_pixels, "resize(10!x10!)"
      
      @controller = ImageMagickGlobalAndLocalRecipesOnlyTestController.new
      
      # local recipe, is allowed
      get :imagemagick, :id=>"presentation.jpg", :commands=>"local_string_ten_pixels"
      assert_image_with_dimensions 10, 10
      
      # global recipe, is also allowed
      get :imagemagick, :id=>"presentation.jpg", :commands=>"global_string_ten_pixels"
      assert_image_with_dimensions 10, 10
      
      # builtin recipe, is not allowed
      get :imagemagick, :id=>"presentation.jpg", :commands=>"resize(10)"
      assert_response 500
      
      ActionController::Macros::ImageMagick::GlobalRecipes.clear
    end
    
    def test_filter
      @controller = ImageMagickAsFilterTestController.new
      
      get :picture, :id=>"existing_image", :commands=>"resize(100!x100!)"
      assert_image_with_dimensions 100, 100
      
      get :picture, :id=>"not_existing_image", :commands=>"resize(100!x100!)"
      assert_equal "not_existing_image", @response.body
      
      get :picture, :id=>"existing_image", :commands=>"unknown_command"
      assert_response 500
    end
    
    private
      def assert_image_with_dimensions(width = nil, height = nil)
        assert_equal "image/jpeg", @response.headers["Content-type"]
        
        pic = Magick::Image.from_blob(@response.body)[0]
        assert_equal width, pic.columns unless width.nil?
        assert_equal height, pic.rows unless height.nil?
      end
  end
  
rescue LoadError
  # RMagick is not installed
end
