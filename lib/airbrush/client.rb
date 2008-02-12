require 'starling'
require 'timeout'

module Airbrush
  include Timeout
  
  class Client
    DEFAULT_INCOMING_QUEUE = 'incoming'
    DEFAULT_TIMEOUT_LENGTH = 30
    
    attr_reader :host

    def initialize(host, outbound_queue = DEFAULT_INCOMING_QUEUE)
      @host = host
      @server = Starling.new(@host)
      @outbound_queue = outbound_queue
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
        queue = unique_name(id)
        
        timeout(DEFAULT_TIMEOUT_LENGTH) do
          return @server.get(queue)
        end
      end
      
      # REVISIT: share implementation with server?
      def unique_name(id)
        id.to_s
      end
      
  end
  
end
