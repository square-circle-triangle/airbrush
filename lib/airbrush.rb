$:.unshift File.dirname(__FILE__)

# required gems
require 'rubygems'
require 'active_support'

Dependencies.load_paths << File.dirname(__FILE__)

# for the moment lets log dependency loading
#Dependencies::RAILS_DEFAULT_LOGGER = Logger.new($stdout)
#Dependencies.log_activity = true

# Load up extensions to existing classes
Dir[File.dirname(__FILE__) + '/airbrush/core_ext/*.rb'].each { |e| require e }

module Airbrush
end

class Object
  def log
    @@__log__ ||= __create_logger__($stdout)
  end

  private

    def __create_logger__(target)
      @@__log__ = ActiveSupport::BufferedLogger.new(target, ActiveSupport::BufferedLogger::Severity::INFO)
    end

end
