module Airbrush  
  class Handler
    attr_reader :processor, :publisher
    
    def initialize(processor, publisher)
      raise ArgumentError, 'no processor specified' unless processor
      raise ArgumentError, 'no publisher specified' unless publisher
      
      @processor = processor
      @publisher = publisher
    end

    def process(id, command, args)
      @publisher.publish id, @processor.dispatch(command, args)
    end

  end
end
