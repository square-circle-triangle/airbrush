module Airbrush
  module Processors
    module Image
      class ImageProcessor < Processor

        def self.before_filter(*symbols)
          @@before_filters = symbols
        end

        def self.after_filter(*symbols)
          @@after_filters = symbols
        end
        
        def dispatch(command, args)
          @@before_filters.each { |filter| filter_dispatch(filter, args) } if @@before_filters
          rv = super command, args
          @@after_filters.each { |filter| filter_dispatch(filter, args) } if @@after_filters
          rv
        end
        
        def filter_dispatch(command, args)
          raise "Unknown processor operation #{command} (#{args.inspect unless args.blank?})" unless self.respond_to? command
          params = assign(command, args)
          self.send command, *params
        end
        
      end
    end
  end
end
