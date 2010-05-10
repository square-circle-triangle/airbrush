require 'RMagick'

module Airbrush
  module Processors
    module Image
      class Rmagick < ImageProcessor
        
        VALID_OUTPUT_FORMATS = ['JPEG', 'PNG', 'JPG', 'GIF']
        
        filter_params :image # ignore any argument called 'image' in any logging

        def resize(image, width, height = nil)
          width, height = calculate_dimensions(image, width) unless height

          process image do
            change_geometry("#{width}x#{height}") { |cols, rows, image| image.resize!(cols, rows) }
          end
        end

        def crop(image, tl_x, tl_y, br_x, br_y)
          process image do
            crop!(tl_x, tl_y, br_x, br_y)
          end
        end

        def crop_resize(image, width, height = nil)
          width, height = calculate_dimensions(image, width) unless height
          
          process image do
            crop_resized!(width, height)
          end
        end

        def previews(image, sizes) # sizes => { :small => [200,100], :medium => [400,200], :large => [600,300] }
          images = sizes.inject(Hash.new) { |m, (k, v)| m[k] = crop_resize(image, *v); m }
          images[:original] = dimensions(image)
          images
        end
        
        
        def resized_crop_mask(image, crop, size)
          process image do
            resize!(size[:width], size[:height])
            crop!(crop[:x], crop[:y], crop[:width], crop[:height])
          end
        end

        protected

          def process(image, &block)
            img = Magick::Image.from_blob(image).first
            img.instance_eval &block
            img.ensure_rgb!
            img.format = get_format(image) # ensure that resized output is a JPEG
            {
              :image => img.to_blob, :width => img.columns, :height => img.rows, :format => img.format
            }
          end
          
          def get_format(image_data)
            current_format = Magick::Image.from_blob(image_data).first.format
            VALID_OUTPUT_FORMATS.include?(current_format) ? current_format : 'JPEG'
          end

          def dimensions(image_data)
            image = Magick::Image.from_blob(image_data).first
            return [image.columns, image.rows]
          end

          def calculate_dimensions(image_data, size)
            image = Magick::Image.from_blob(image_data).first
            return image.columns, image.rows unless clipping_required?(image, size)

            ratio = image.columns.to_f / image.rows.to_f

            return [ size, size.to_f / ratio ] if ratio > 1 # landscape
            
            return [ ratio * size, size ] if ratio < 1      # Portrait
            
            return [ size, size ]                           # Square
          end

          def clipping_required?(image, size)
            (image.columns > size) || (image.rows > size)
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
      return if rgb?

      if cmyk?
        add_profile SCT_CMYK_ICC if color_profile == nil
        add_profile SCT_SRGB_ICC
        log.debug "Added sRGB profile to image"
      else
        log.warn "Non CMYK/RGB color profile encountered, please install a profile for #{colorspace} and update ensure_rgb! implementation"
      end
    end

    private

      def rgb?
        colorspace == Magick::RGBColorspace
      end

      def cmyk?
        colorspace == Magick::CMYKColorspace
      end
  end
end
