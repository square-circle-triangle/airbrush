require 'memcache'

module Airbrush
  module Publishers
    class Memcache < Publisher
      attr_reader :host
      
      def initialize(host)
        @host = host
      end

      def publish(id, results)
        # need to calculate an outboue queue name somehow, client will also need this to get the results
        name = unique_name(id)
        queue = MemCache.new(@host)
        queue.set(name, results)
        
        log.debug "Published results from #{name}"
      end
    end
  end
end