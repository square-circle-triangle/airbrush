require 'memcache'

module Airbrush
  module Listeners
    class Memcache < Listener
      DEFAULT_POLL_FREQUENCY = 2 # seconds
      DEFAULT_INCOMING_QUEUE = 'incoming'
      
      attr_reader :host, :poll_frequency
      
      def initialize
        @poll_frequency = DEFAULT_POLL_FREQUENCY
        @host = '127.0.0.1:22122' # REVISIT: have to configure detection of memcache host (dnssd or command line option)
      end
    
      def start
        starling = MemCache.new(@host)
        
        loop do
          process(starling)
          sleep @poll_frequency # REVISIT: configurable
        end
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
            puts "Received error during handler #{e}"
          end
      
        end
        
        def valid?(op)
          return false unless op.is_a? Hash
          return false unless op[:command]
          return false unless op[:args]
          true
        end
      
    end
  end
end
