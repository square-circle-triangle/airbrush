module Airbrush
  class Server
    attr_reader :listener
    
    def initialize(context = {})
      @listener = Airbrush::Listeners::Memcache.new(context[:memcache])
      @listener.handler = Handler.new(Processors::Rmagick.new, Publishers::Memcache.new(context[:memcache]))      
    end
    
    def start
      @listener.start
    end
    
  end
end
