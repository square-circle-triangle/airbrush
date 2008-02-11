require 'memcache'

module Airbrush
  module Listeners
    class Memcache < Listener
      DEFAULT_POLL_FREQUENCY = 2 # seconds
      DEFAULT_INCOMING_QUEUE = 'incoming'
      
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
          process(@starling)
          break unless @running
          sleep @poll_frequency
        end
        
        @starling.reset
      end
      
      private
      
        def process(starling)
          op = starling.get(DEFAULT_INCOMING_QUEUE)
      
          # command format from client  :command => :resize, :args => { :image => blob, :width => 300, :height => 200 }
      
          return unless op
          
          unless valid?(op)
            log.error "Received invalid job #{op}"
            return
          end
          
          log.debug "Processing #{op}"
          
          begin
            @handler.process op[:id], op[:command], op[:args]
          rescue Exception => e
            log.error 'Received error during handler'
            log.error e
          end
          
          log.debug "Processed #{op}"
        end
        
        def valid?(op)
          return false unless op.is_a? Hash
          return false unless op[:id]
          return false unless op[:command]
          return false unless op[:args]
          true
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
