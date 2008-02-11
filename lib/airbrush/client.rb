require 'memcache'

module Airbrush
  
  class Client
    DEFAULT_POLL_FREQUENCY = 2 # seconds
    DEFAULT_INCOMING_QUEUE = 'incoming'
    
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
        
        loop do
          results = @server.get(unique_name(id))
          return results unless results.nil?
          
          sleep @poll_frequency
        end
      end
  end
  
end
