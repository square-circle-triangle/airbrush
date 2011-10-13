class Object
  def log(out=$stdout)
     @@logger ||= __create_logger__(out)
  end

  private

    def __create_logger__(target)
      @@logger = Logger.new(target)
      @@logger.level = Logger::INFO
      @@logger.formatter = Logger::Formatter.new
      @@logger
    end

end
