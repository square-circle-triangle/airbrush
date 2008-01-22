module Airbrush
  module Processors
    class Processor
      def method_missing(sym, args, &block)
        raise "Unknown processor operation #{sym} (#{args.inspect unless args.blank?})"
      end
    end
  end
end
