module Airbrush
  module Processors
    module Image
      module Preprocessors
        class Preprocessor
          def process(file)
            raise 'Concrete classes implement this'
          end
        end
      end
    end
  end
end