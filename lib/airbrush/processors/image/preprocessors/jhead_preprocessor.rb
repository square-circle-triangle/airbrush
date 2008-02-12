module Airbrush
  module Processors
    module Image
      module Preprocessors
        class JheadPreprocessor < Preprocessor

          def process(image)
            return if not jpeg?(image)
            system "jhead -purejpg #{image}"
          end
          
          private
          
            def jpeg?(image)
              image.downcase =~ /(jpg|jpeg)$/
            end
            
        end
      end
    end
  end
end