require 'starling'
require 'timeout'

module Airbrush
  include Timeout
  class AirbrushProcessingError < StandardError; end

  class Client
    DEFAULT_INCOMING_QUEUE   = 'airbrush_incoming_queue'
    DEFAULT_RESPONSE_TIMEOUT = 120
    DEFAULT_QUEUE_VALIDITY   = 0 # 10.minutes for the moment

    attr_reader :host, :incoming_queue, :response_timeout, :queue_validity

    def initialize(host, incoming_queue = DEFAULT_INCOMING_QUEUE, response_timeout = DEFAULT_RESPONSE_TIMEOUT, queue_validity = DEFAULT_QUEUE_VALIDITY)
      @host = host
      @server = Starling.new(@host)
      @incoming_queue = incoming_queue
      @response_timeout = response_timeout
      @queue_validity = queue_validity.to_i
    end

    def process(id, command, args = {})
      raise 'No job id specified' unless id
      raise 'No command specified' unless command
      raise "Invalid arguments #{args}" unless args.is_a? Hash

      send_and_receive(id, command, args)
    end

    private

      def send_and_receive(id, command, args)
        @server.set(@incoming_queue, { :id => id, :command => command, :args => args }, @queue_validity, false)
        queue = unique_name(id)
        Timeout::timeout(@response_timeout) do
          response = @server.get(queue)
          raise AirbrushProcessingError, format_error(response) if response.include? :exception
          return response
        end
      end

      # REVISIT: share implementation with server?
      def unique_name(id)
        id.to_s
      end

      def format_error(response)
        "#{response[:exception]}: #{response[:message]}"
      end

  end
end
