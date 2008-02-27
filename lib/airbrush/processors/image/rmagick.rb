require 'RMagick'

module Airbrush
  module Processors
    module Image
      class Rmagick < ImageProcessor
        
        def resize(image, width, height)
          img = load(image)
          img.change_geometry("#{width}x#{height}") { |cols, rows, image| img.resize!(cols, rows) }
          img.ensure_rgb!
          img.to_blob
        end
        
        def crop(image, tl_x, tl_y, br_x, br_y)
          img = load(image)
          img.crop!(tl_x, tl_y, br_x, br_y)
          img.ensure_rgb!
          img.to_blob
        end

        def crop_resize(image, width, height)
          img = load(image)
          img.crop_resized!(width, height)
          img.ensure_rgb!
          img.to_blob
        end
        
        def previews(image, sizes) # sizes => { :small => [200,100], :medium => [400,200], :large => [600,300] }
          sizes.inject(Hash.new) { |m, (k, v)| m[k] = crop_resize(image, *v); m }
        end
        
        protected
        
          def load(image)
            img = Magick::Image.from_blob(image).first
          end
        
      end
    end
  end
end

module Magick
  class Image
    SCT_CMYK_ICC = File.dirname(__FILE__) + '/profiles/cmyk-profile.icc'
    SCT_SRGB_ICC = File.dirname(__FILE__) + '/profiles/srgb-profile.icc'
    
    def ensure_rgb!
      return if colorspace == Magick::RGBColorspace
      
      add_profile SCT_CMYK_ICC if color_profile == nil and colorspace == Magick::CMYKColorspace
      add_profile SCT_SRGB_ICC
      
      log.debug "Added sRGB profile to image"
    end
  end
end
