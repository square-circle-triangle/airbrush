module Airbrush
  module Listeners
    class Listener
      attr_accessor :handler
      
      def start
        raise 'implementations provide concrete listener functionality'
      end
      
      protected
      
        def process(op)
          raise 'No operation specified' unless op
          
          unless valid?(op)
            log.error "Received invalid job #{op}"
            return
          end
          
          log.debug "Processing #{op[:id]}"
          start = Time.now
          
          begin
            @handler.process op[:id], op[:command], op[:args]
          rescue Exception => e
            log.error 'Received error during handler'
            log.error e
          ensure
            log.debug "Processed #{op[:id]}: #{Time.now - start} seconds processing time"
          end
        end
        
      private
        
        def valid?(op)
          return false unless op.is_a? Hash
          return false unless op[:id]
          return false unless op[:command]
          return false unless op[:args]
          true
        end
        
    end
  end
end