require 'airbrush/core_ext/get_args'

module Airbrush
  module Processors
    class Processor
      
      def dispatch(command, args)
        raise "Unknown processor operation #{command} (#{args.inspect unless args.blank?})" unless respond_to? command
        params = assign(command, args)
        self.send command, *params
      end
            
      private
      
        def assign(command, args)
          params = ParseTreeArray.translate(self.class, command).get_args
          params.collect do |param|
            name, default = *param
            args[name] ? args[name] : (raise "No value (default or otherwise) provided for #{name}" unless default; default)            
          end
        end
      
    end
  end
end
