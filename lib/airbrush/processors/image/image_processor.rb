module Airbrush
  module Processors
    module Image
      class ImageProcessor < Processor
        class_inheritable_accessor :before_filters, :after_filters

        def self.before_filter(*symbols)
          self.before_filters = symbols
        end

        def self.after_filter(*symbols)
          self.after_filters = symbols
        end
        
        def dispatch(command, args)
          self.before_filters.each { |filter| filter_dispatch(filter, args) } if self.before_filters
          rv = super command, args
          self.after_filters.each { |filter| filter_dispatch(filter, args) } if self.after_filters
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
