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
      
          return unless op and valid?(op)
          
          begin
            @handler.process op[:command], op[:args]
          rescue Exception => e
            # REVISIT: log bad command
            puts "Received error during handler '#{e}'"
          end
      
        end
        
        def valid?(op)
          return false unless op.is_a? Hash
          return false unless op[:command]
          return false unless op[:args]
          true
        end
        
        def catch_signals(*signals)
          signals.each do |signal|
            Signal.trap(signal.to_s.upcase) do
              @running = false
            end
          end
        end
    end
  end
end
