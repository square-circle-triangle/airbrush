require 'airbrush/core_ext/get_args'

module Airbrush
  module Processors
    class Processor

      def dispatch(command, args)
        raise "Unknown processor operation #{command} (#{args.inspect unless args.blank?})" unless self.respond_to? command
        params = assign(command, args)
        self.send command, *params
      rescue Exception => e
        log.error 'Received error during processor dispatch'
        log.error e
        e.message
      end
                  
      protected
      
        def assign(command, args)
          params = ParseTreeArray.translate(self.class, command).get_args
          params.collect do |param|
            name, default = *param
            args[name] ? args[name] : (raise "No value (default or otherwise) provided for #{name} in #{command}" unless default; default)            
          end
        end
      
    end
  end
end
