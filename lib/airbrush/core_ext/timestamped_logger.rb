module ActiveSupport
  class BufferedLogger

    def add_with_timestamps(severity, message = nil, progname = nil, &block)
      add_without_timestamps(severity, "#{Time.now}: #{message}", progname, &block)
    end

    alias_method_chain :add, :timestamps

  end
end
