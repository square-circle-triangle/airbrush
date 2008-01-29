require 'memcache'

module Airbrush
  module Publishers
    class Memcache < Publisher
      attr_reader :host
      
      def initialize(host)
        @host = host
      end

      def publish(results)
        # need to calculate an outboue queue name somehow, client will also need this to get the results
        queue = MemCache.new(@host)
        queue.set('result-queue', results)
      end
    end
  end
end

# resize the dnssd or command line gear in listeners?