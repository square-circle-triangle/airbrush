module Airbrush
  module Processors
    class Processor
      class_inheritable_accessor :filtered_params

      def dispatch(command, args)
        raise "Unknown processor operation #{command} (#{filter(args).inspect unless args.blank?})" unless self.respond_to? command
        returning self.send(command, *assign(command, args)) do
          log.debug "Processed #{command} (#{filter(args).inspect unless args.blank?})"
        end
      rescue Exception => e
        buffer = "ERROR: Received error during processor dispatch for command '#{command}' (#{filter(args).inspect unless args.blank?})"
        log.error buffer; log.error e
        { :exception => buffer, :message => e.message }
      end

      def self.filter_params(*symbols)
        self.filtered_params = symbols
      end

      protected

        def assign(command, args)
          params = ParseTreeArray.translate(self.class, command).get_args
          params.collect do |param|
            name, default = *param
            args[name] ? args[name] : (raise "No value (default or otherwise) provided for #{name} in #{command}" unless default; default)
          end
        end

      private

        def filter(args)
          return args if self.filtered_params.blank?

          args.dup.inject({}) do |m, (k, v)|
            m[k] = self.filtered_params.include?(k) ? '[FILTERED]' : v; m
          end
        end

    end
  end
end
