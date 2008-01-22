module Airbrush
  class Server
    
    def initialize(context)
      @listener = Airbrush::Listeners::Memcache.new
      @listener.handler = Handler.new(Processors::CoreImage.new, Publishers::Memcache.new)      
    end
    
    def start
      @listener.start
    end
    
  end
end
