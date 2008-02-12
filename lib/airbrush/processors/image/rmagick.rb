require 'RMagick'

module Airbrush
  module Processors
    module Image
      class Rmagick < ImageProcessor
        before_filter :purify_image
        
        def resize(image, width, height)
          img = load(image)
          img.change_geometry("#{width}x#{height}") { |cols, rows, image| img.resize!(cols, rows) }
          img.to_blob
        end

        def crop(image, tl_x, tl_y, br_x, br_y)
          img = load(image)
          img.crop!(tl_x, tl_y, br_x, br_y)
          img.to_blob
        end

        def crop_resize(image, width, height)
          img = load(image)
          img.crop_resized!(width, height, Magick::NorthGravity)
          img.to_blob
        end
        
        def previews(image, sizes) # sizes => { :small => [200,100], :medium => [400,200], :large => [600,300] }
          sizes.inject(Hash.new) { |m, kv| m[kv.first] = crop_resize(image, *kv.last); m }
        end
        
        protected
        
          def load(image)
            img = Magick::Image.from_blob(image).first
          end
          
          def purify_image(image)
            system "jhead -purejpg #{image}" if jpeg?(image)
          end
          
          def jpeg?(image)
            image.downcase =~ /(jpg|jpeg)$/
          end
      end
    end
  end
end
