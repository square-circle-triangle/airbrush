module Airbrush
  class Server
    attr_reader :listener
    
    def initialize(context = {})
      memcache_host = context[:memcache]
      memcache_poll = context[:frequency]
      log.level = context[:verbose] ? Logger::DEBUG : Logger::ERROR
      
      @listener = Airbrush::Listeners::Memcache.new(memcache_host, memcache_poll)
      @listener.handler = Handler.new(Processors::Rmagick.new, Publishers::Memcache.new(memcache_host))
    end
    
    def start
      @listener.start
    end
    
  end
end
