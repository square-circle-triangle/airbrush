require 'RMagick'

module Airbrush
  module Processors
    module Image
      class Rmagick < ImageProcessor
        before_filter :preprocess, :create_image
        
        def resize(image, width, height)
          @img.change_geometry("#{width}x#{height}") { |cols, rows, image| @img.resize!(cols, rows) }
          @img.to_blob
        end

        def crop(image, tl_x, tl_y, br_x, br_y)
          @img.crop(tl_x, tl_y, br_x, br_y)
          @img.to_blob
        end

        def crop_resized(image, width, height)
          @img.crop_resized!(width, height, Magick::NorthGravity)
          @img.to_blob
        end
        
        protected
        
          def create_image(image)
            @img = Magick::Image.from_blob(image).first
          end
          
          def preprocess(image)
            @@preprocessors.each { |processor| processor.process image }
          end
      end
    end
  end
end
