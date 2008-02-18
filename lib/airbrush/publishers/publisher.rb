module Airbrush
  module Publishers
    class Publisher
      
      def publish
        raise 'implementations provide concrete publisher functionality'
      end

      protected
      
        def unique_name(id)
          id.to_s
        end
    end
  end
end
