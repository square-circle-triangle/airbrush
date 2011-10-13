$:.unshift File.dirname(__FILE__)

# required gems
require 'active_support'
require 'active_support/dependencies'
require 'active_support/time'
require 'active_support/core_ext'

ActiveSupport::Dependencies.autoload_paths << File.dirname(__FILE__)

# for the moment lets log dependency loading
#Dependencies::RAILS_DEFAULT_LOGGER = Logger.new($stdout)
#Dependencies.log_activity = true

# Load up extensions to existing classes
Dir[File.dirname(__FILE__) + '/airbrush/core_ext/*.rb'].each { |e| require e }

module Airbrush
end

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
