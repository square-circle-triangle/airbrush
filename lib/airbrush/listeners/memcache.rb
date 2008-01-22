require 'memcache'

module Airbrush
  module Listeners
    class Memcache < Listener
      
      def initialize
        @host = '127.0.0.1:22122' # REVISIT: have to configure detection of memcache host (dnssd or command line option)
      end
    
      def start
        starling = MemCache.new(@host)
      
        loop do
          op = starling.get('incoming')
          
          puts "op is #{op}"
          
          unless op
            sleep 2 # REVISIT: configurable
            next
          end
          
          puts "handling op #{op}"
          
          begin
            @handler.process op[:command], op[:args]
          rescue
            # REVISIT: log bad command
          end
          
          puts "#{op} handled"
        end
      
        # command format from client  :command => :resize, :args => { :image => blob, :width => 300, :height => 200 }
      end
    end
  end
end
