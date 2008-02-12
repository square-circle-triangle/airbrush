module Airbrush
  module Processors
    module Image
      class ImageProcessor < Processor

        def self.before_filter(*symbols)
          @@filters = symbols
        end
        
        def dispatch(command, args)
          @@filters.each { |filter| filter_dispatch(filter, args) }
          super command, args
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
