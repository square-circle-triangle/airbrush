require 'starling'
require 'timeout'

module Airbrush
  include Timeout
  
  class Client
    DEFAULT_INCOMING_QUEUE = 'incoming'
    DEFAULT_TIMEOUT_LENGTH = 2.minutes
    
    attr_reader :host, :incoming_queue, :timeout

    def initialize(host, incoming_queue = DEFAULT_INCOMING_QUEUE, timeout = DEFAULT_TIMEOUT_LENGTH)
      @host = host
      @server = Starling.new(@host)
      @incoming_queue = incoming_queue
      @timeout = timeout
    end
    
    def process(id, command, args = {})
      raise 'No job id specified' unless id
      raise 'No command specified' unless command
      raise "Invalid arguments #{args}" unless args.is_a? Hash
      
      send_and_receive(id, command, args)
    end
    
    private
    
      def send_and_receive(id, command, args)
        @server.set(@incoming_queue, :id => id, :command => command, :args => args)
        queue = unique_name(id)
        
        Timeout::timeout(@timeout) do
          return @server.get(queue)
        end
      end
      
      # REVISIT: share implementation with server?
      def unique_name(id)
        id.to_s
      end
      
  end
  
end
