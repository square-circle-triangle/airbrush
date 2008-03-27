require 'memcache'

module Airbrush
  module Listeners
    class Memcache < Listener
      DEFAULT_POLL_FREQUENCY = 2 # seconds
      DEFAULT_INCOMING_QUEUE = 'airbrush_incoming_queue'
      
      attr_reader :host, :poll_frequency
      
      def initialize(host, frequency = DEFAULT_POLL_FREQUENCY)
        @host = host
        @poll_frequency = frequency
        catch_signals(:int)
      end
    
      def start
        @running = true
        @starling = MemCache.new(@host)
        
        log.debug 'Accepting incoming jobs'
        
        loop do
          poll do |operation|
            process operation
          end
          
          break unless @running
          sleep @poll_frequency
        end
        
        @starling.reset
      end
      
      private
      
        def poll
          operation = @starling.get(DEFAULT_INCOMING_QUEUE)
          yield operation if operation and block_given?
        end
        
        def catch_signals(*signals)
          signals.each do |signal|
            sig = signal.to_s.upcase
            Signal.trap(sig) do
              @running = false
              log.debug "Intercepted SIG#{sig}, exiting"
            end
          end
        end
    end
  end
end
