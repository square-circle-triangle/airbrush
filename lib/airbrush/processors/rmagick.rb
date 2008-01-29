require 'RMagick'

module Airbrush
  module Processors
    class Rmagick < Processor
      def resize(image, width, height)
        img = Magick::Image.from_blob(image).first
        img.change_geometry("#{width}x#{height}") { |cols, rows, image| img.resize!(cols, rows) }
        img.to_blob
      end
    end
  end
end
