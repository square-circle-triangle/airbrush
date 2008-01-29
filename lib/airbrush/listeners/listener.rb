module Airbrush
  module Listeners
    class Listener
      attr_accessor :handler
      
      def start
        raise RuntimeError, 'implementations provide concrete listener functionality'
      end
      
    end
  end
end