module ActionView
  module Helpers
    #
    # Provides helpers for using ImageMagick. These helpers rely on the corresponding ImageMagick
    # macro in the controller. See ActionController::Macros::ImageMagick::ClassMethods
    #
    # You can use the following ImageMagick commands with this helper:
    # (see http://imagemagick.org/script/command-line-options.php for a description of what they
    # do).
    #
    # * <tt>resize(100x100)</tt>, aliases <tt>s</tt> and <tt>geometry</tt>
    # * <tt>blur(1.0,1.0)</tt>, alias <tt>blur_image</tt>
    # * <tt>crop(10,10,30,30)</tt>
    # * <tt>colorize(0.5,0.5,0.5,ffff00)</tt>
    # * <tt>equalize</tt>
    # * <tt>flip</tt>
    # * <tt>flop</tt>
    # * <tt>implode(2.0)</tt>
    # * <tt>level(0.3,0.1)</tt>
    # * <tt>normalize</tt>
    # * <tt>oilpaint(2.0)</tt>
    # * <tt>opaque(ffffff,ffff00)</tt>
    # * <tt>posterize(10)</tt>
    # * <tt>sharpen(0.2,0.3)</tt>
    # * <tt>rotate(45)</tt>
    # * <tt>border(10,10,ffff00)</tt>
    # * <tt>trim</tt>
    #
    # And, as a special service to Rails users, this extension has a method that is not
    # available for ImageMagick, but can be very useful:
    #
    # * <tt>part(100x100)</tt>, will give you a part of the image with exactly
    #   the given proportions (in this case, 100x100 pixels). The original image
    #   will be resized to match either the required width or height, depending on
    #   the aspect ratio. The image is then centered and the left and right, or
    #   top and bottom, slack is cut off. Thus, +part+ will always give you an
    #   image of the same size.
    #
    # You can also define and use your own 'recipes'. See the documentation for
    # ActionController::Macros::ImageMagick::RecipeSet
    #
    module ImageMagickMacroHelper
      #
      # The workings of this function depend on how you enabled the imagemagick extension:
      # as a separate action, or as an after_filter for your own action.
      #
      # === As an action
      #
      # Returns an image tag for the image with the given +filename, which will be rendered with the
      # given ImageMagick +commands+.
      # 
      # +filename_or_params+ should point to an image in the directory you specified with
      # +imagemagick_for+. You can have subdirectories, in that case you prepend the
      # name of the subdirectory to +filename_or_params+
      #
      # +commands+ can be a +String+ of commands, separated by plus signs:
      #    "resize(100x100)+flop+rotate(45)"
      #
      # or, +commands+ can be an +Array+ of command strings and command+argument arrays:
      #    [ ["resize", "100x100"], "flop", ["rotate", "45"] ]
      #
      # The +options+ will be forwarded to the normal +image_tag+ method (and will be used as
      # the html attributes.) The only exception is this +option+:
      # <tt>:controller</tt>:: the name of the controller in which the ImageMagick macro is
      #                        activated. It defaults to the current controller, but you can
      #                        specify something else.
      #
      # Examples:
      #    <%= imagemagick_tag "presentation.png", "resize(100x100)+flop", :alt=>"Presentation" %>
      #    <%= imagemagick_tag "presentation.png", "equalize", :controller=>"photo", :alt=>"Presentation" %>
      #    <%= imagemagick_tag "presentation.png", "equalize" %>
      #    <%= imagemagick_tag "rails/presentation.png", "equalize" %>
      #
      #
      # === As an after_filter
      #
      # Returns an image tag for the action with the parameters in +filename_or_params+ (in +url_form+ format).
      # The result of that action will be rendered with the given ImageMagick +commands+.
      # 
      # +filename_or_params+ should be the +url_for+ options hash that points to the action that renders the
      # image. You can use any parameters your action need.
      #
      # +commands+ can be a +String+ of commands, separated by plus signs:
      #    "resize(100x100)+flop+rotate(45)"
      #
      # or, +commands+ can be an +Array+ of command strings and command+argument arrays:
      #    [ ["resize", "100x100"], "flop", ["rotate", "45"] ]
      #
      # The +options+ will be forwarded to the normal +image_tag+ method (and will be used as
      # the html attributes.)
      #
      # Instead of provinding a separate +commands+ argument, you can also specify the commands as
      # the <tt>:commands</tt> parameters in the +url_for+ hash. (If you have renamed <tt>:commands</tt> in
      # the configuration, you should use the new name instead.)
      #
      # Examples:
      #    <%= imagemagick_tag({:action=>'display_image', :id=>10}, 'resize(100x100)+flop', {:alt=>"Presentation"}) %>
      #    <%= imagemagick_tag({:controller=>'photo', :action=>'display_image', :id=>10}, 'resize(100x100)+flop', {:alt=>"Presentation"}) %>
      #    <%= imagemagick_tag :action=>'display_image', :id=>10, :user=>10, :other_param=>'abc', :commands=>'equalize' %>
      #
      def imagemagick_tag(filename_or_params, commands = nil, options = {})
        image_tag_options = Hash.new.merge!(options)
        image_tag_options.delete(:controller)
        return image_tag(imagemagick_path(filename_or_params, commands, options), image_tag_options)
      end
      
      #
      # Returns the path for the image, which will be rendered with the
      # given ImageMagick +commands+.
      #
      # +filename_or_params+ and +commands+ works the same as for +imagemagick_tag+.
      # +options+ does nothing.
      #
      def imagemagick_path(filename_or_params, commands = [], options = {})
        if (filename_or_params.is_a?(Hash))
          return imagemagick_controller(filename_or_params).url_for_imagemagick(filename_or_params, commands)
        else
          return imagemagick_controller(options).url_for_imagemagick(filename_or_params, commands)
        end
      end
      
    private
      def imagemagick_controller(options)
        options[:controller] ? (options[:controller].camelize + "Controller").constantize.new : @controller
      end
    end
  end
end
