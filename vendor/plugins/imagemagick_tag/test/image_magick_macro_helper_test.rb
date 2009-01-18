require 'test/unit'

begin
  require "RMagick"

  class ImageMagickMacroHelperTest < Test::Unit::TestCase
    class CustomUrlForController < ActionController::Base
      def url_for(options, *parameters_for_method_reference)
        options
      end
    end
    
    class ImageMagickNonCachingTestController < CustomUrlForController
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick")
    end
    
    class ImageMagickCachingPrerenderingTestController < CustomUrlForController
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick"),
                      :cache=>"/tmp/imagemagick_cache",
                      :prerender=>true
    end
    
    class ImageMagickForTagTestController < ActionController::Base
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick")
      
      def url_for(options, *parameters_for_method_reference)
        options.to_s
      end
    end
    class ImageMagickForTagTestRequest
      def relative_url_root
        ""
      end
    end
    
    class ImageMagickCustomActionTestController < CustomUrlForController
      imagemagick_for File.expand_path(File.dirname(__FILE__) + "/../fixtures/imagemagick"),
                      :action_name=>"customaction"
    end
    
    class ImageMagickForPathAsFilterTestController < CustomUrlForController
      imagemagick_filter_for :picture, :id_param=>"image_name"
    end
    
    class ImageMagickForTagAsFilterTestController < ActionController::Base
      imagemagick_filter_for :picture
      
      def url_for(options, *parameters_for_method_reference)
        options.to_s
      end
    end
    
    include ActionView::Helpers::ImageMagickMacroHelper
    
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::AssetTagHelper
    
    def setup
      @controller = ImageMagickNonCachingTestController.new
      @controller_cache = ImageMagickCachingPrerenderingTestController.new
      
      FileUtils.mkdir("/tmp/imagemagick_cache")
    end
    
    def teardown
      FileUtils.rm_rf("/tmp/imagemagick_cache")
    end
    
    def test_imagemagick_path_without_commands
      expected_path = { :action=>"imagemagick",
                        :id=>"presentation.jpg" }
      assert_equal expected_path, imagemagick_path("presentation.jpg")
    end
  
    def test_imagemagick_path_with_commands
      expected_path = { :action=>"imagemagick",
                        :id=>"presentation.jpg",
                        :commands=>"resize(10)" }
      assert_equal expected_path, imagemagick_path("presentation.jpg", [[:resize,10]])
    end
  
    def test_imagemagick_path_with_prerendering
      @controller = @controller_cache
      expected_path = { :action=>"imagemagick",
                        :id=>"presentation.jpg",
                        :commands=>"resize(10)+equalize" }
      assert_equal expected_path, imagemagick_path("presentation.jpg", [[:resize,10],[:equalize]])
      
      assert File.exists?("/tmp/imagemagick_cache/ImageMagickMacroHelperTestImageMagickCachingPrerenderingTestController.resize10.equalize.presentation.jpg")
    end
  
    def test_imagemagick_path_other_controller
      expected_path = { :action=>"imagemagick",
                        :id=>"presentation.jpg",
                        :commands=>"resize(10)+equalize" }
      
      # should use the ImageMagickCachingPrerenderingTestController
      assert_equal expected_path, imagemagick_path("presentation.jpg", [[:resize,10],[:equalize]],
                                               {:controller=>'ImageMagickMacroHelperTest::ImageMagickCachingPrerenderingTest'})
      
      assert File.exists?("/tmp/imagemagick_cache/ImageMagickMacroHelperTestImageMagickCachingPrerenderingTestController.resize10.equalize.presentation.jpg")
    end
    
    def test_imagemagick_tag
      @controller = ImageMagickForTagTestController.new
      @request = ImageMagickForTagTestRequest.new
      
      assert imagemagick_tag("presentation.jpg") =~ /presentation.jpg/
      assert imagemagick_tag("presentation.jpg", "resize(100x100)") =~ /resize/
      assert imagemagick_tag("presentation.jpg", "x", :height=>100) =~ /height="100"/
    end
    
    def test_custom_action_imagemagick_path
      @controller = ImageMagickCustomActionTestController.new
      
      expected_path = { :action=>"customaction",
                        :id=>"presentation.jpg" }
      assert_equal expected_path, imagemagick_path("presentation.jpg")
    end
    
    def test_filter_imagemagick_path
      @controller = ImageMagickForPathAsFilterTestController.new
      
      expected_path = { :action=>:picture,
                        :image_name=>"presentation.jpg",
                        :commands=>"resize(100)" }
      assert_equal expected_path, imagemagick_path({ :action=>:picture, :image_name=>"presentation.jpg" }, "resize(100)")
    end
    
    def test_filter_imagemagick_tag
      @controller = ImageMagickForTagAsFilterTestController.new
      @request = ImageMagickForTagTestRequest.new
      
      assert imagemagick_tag({ :action=>:picture, :id=>"presentation.jpg" }) =~ /idpresentation.jpg/
      assert imagemagick_tag({ :action=>:picture, :id=>"presentation.jpg" }, "resize(100)") =~ /idpresentation.jpg.*resize/
    end
  end

rescue LoadError
  # RMagick is not installed
end
