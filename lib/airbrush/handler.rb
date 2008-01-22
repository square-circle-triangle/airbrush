module Airbrush  
  class Handler
    
    def initialize(processor, publisher)
      @processor = processor
      @publisher = publisher
    end

    def process(command, args)
      @publisher.publish @processor.send(command, args)
    end
    
  end
end