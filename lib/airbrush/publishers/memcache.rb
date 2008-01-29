require 'memcache'

module Airbrush
  module Publishers
    class Memcache < Publisher
      attr_reader :host
      
      def initialize
        @host = '192.168.1.1:22122'
      end

      def publish(results)
        # need to calculate an outboue queue name somehow, client will also need this to get the results
        queue = MemCache.new(@host)
        queue.set('my result', results)
      end
    end
  end
end

# resize the dnssd or command line gear in listeners?