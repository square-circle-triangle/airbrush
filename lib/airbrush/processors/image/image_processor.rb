module Airbrush
  module Processors
    module Image
      class ImageProcessor < Processor
        cattr_accessor :preprocessors
        
        @@preprocessors = [ Preprocessors::JheadPreprocessor.new ]
        
        protected
      
          def preprocess(image)
            @@preprocessors.each { |processor| processor.process image }
          end
        
      end
    end
  end
end
