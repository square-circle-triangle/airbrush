ActiveSupport::Dependencies.autoload_paths << File.join(File.dirname(__FILE__), '..')
# Load up extensions to existing classes
Dir[File.dirname(__FILE__) + '/core_ext/*.rb'].each { |e| require e }

module Airbrush
  class Server
    attr_reader :listener

    def initialize(context = {})
      memcache_host = context[:memcache]
      memcache_poll = context[:frequency]
      Object.send :__create_logger__, context[:log_target] if context.include? :log_target
      log.level = context[:verbose] ? ActiveSupport::BufferedLogger::Severity::DEBUG : ActiveSupport::BufferedLogger::Severity::INFO

      @listener = Airbrush::Listeners::Memcache.new(memcache_host, memcache_poll)
      @listener.handler = Handler.new(Processors::Image::Rmagick.new, Publishers::Memcache.new(memcache_host))
    end

    def start
      @listener.start
    end

  end
end
