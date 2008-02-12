module Airbrush
  module Processors
    module Image
      module Preprocessors
        class JheadPreprocessor < Preprocessor

          def initialize
            #raise 'jhead is not installed on this system' unless system 'which jhead'
          end
          
          def process(image)
            system "jhead -purejpg #{image}"
          end

        end
      end
    end
  end
end