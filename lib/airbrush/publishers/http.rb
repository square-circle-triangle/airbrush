module Airbrush
  module Publishers
    class Http < Publisher
      def initialize(target)
        @target = target
      end
      
      def publish(result)
        # http post/put to target
      end
    end
  end
end