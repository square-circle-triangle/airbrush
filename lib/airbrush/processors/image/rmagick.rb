require 'RMagick'

module Airbrush
  module Processors
    module Image
      class Rmagick < ImageProcessor
        filter_params :image # ignore any argument called 'image' in any logging

        def resize(image, width, height)
          load(image) do
            change_geometry("#{width}x#{height}") { |cols, rows, image| img.resize!(cols, rows) }
            ensure_rgb!
            format = 'JPEG' # ensure that resized output is a JPEG
            to_blob
          end
        end

        def crop(image, tl_x, tl_y, br_x, br_y)
          load(image) do
            crop!(tl_x, tl_y, br_x, br_y)
            ensure_rgb!
            format = 'JPEG'
            to_blob
          end
        end

        def crop_resize(image, width, height)
          load(image) do
            crop_resized!(width, height)
            ensure_rgb!
            format = 'JPEG'
            to_blob
          end
        end

        def previews(image, sizes) # sizes => { :small => [200,100], :medium => [400,200], :large => [600,300] }
          sizes.inject(Hash.new) { |m, (k, v)| m[k] = crop_resize(image, *v); m }
        end

        protected

          def load(image, &block)
            img = Magick::Image.from_blob(image).first
            img.instance_eval &block
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
