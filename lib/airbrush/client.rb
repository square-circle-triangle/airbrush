require 'memcache'
require 'timeout'

module Airbrush
  include Timeout
  
  class Client
    DEFAULT_INCOMING_QUEUE = 'incoming'
    DEFAULT_POLL_FREQUENCY = 2.seconds
    DEFAULT_TIMEOUT_LENGTH = 30.second
    
    attr_reader :host, :poll_frequency
    
    def initialize(host, outbound_queue = DEFAULT_INCOMING_QUEUE, poll_frequency = DEFAULT_POLL_FREQUENCY)
      @host = host
      @server = MemCache.new(@host)
      @outbound_queue = outbound_queue
      @poll_frequency = poll_frequency
    end
    
    def process(id, command, args = {})
      raise 'No job id specified' unless id
      raise 'No command specified' unless command
      raise "Invalid arguments #{args}" unless args.is_a? Hash
      
      send_and_receive(id, command, args)
    end
    
    private
    
      def send_and_receive(id, command, args)
        @server.set(@outbound_queue, :id => id, :command => command, :args => args)
        
        timeout(DEFAULT_TIMEOUT_LENGTH) do
          loop do
            poll(id) do |results|
              return results
            end
          
            sleep @poll_frequency
          end
        end
      end
      
      def poll(id)
        results = @server.get(unique_name(id))
        yield results if results and block_given?
      end

      # REVISIT: share implementation with server?
      def unique_name(id)
        id.to_s
      end
      
  end
  
end
