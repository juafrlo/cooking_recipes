# Include hook code here
require "image_magick"
require "image_magick_macro_helper"

ActionController::Base.class_eval do
  include ActionController::Macros::ImageMagick
end

ActionView::Base.class_eval do
  include ActionView::Helpers::ImageMagickMacroHelper
end
