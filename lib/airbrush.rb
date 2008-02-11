$:.unshift File.dirname(__FILE__)

# required gems
require 'rubygems'
require 'logger'
require 'active_support'

Dependencies.load_paths << File.dirname(__FILE__)

# for the moment lets log dependency loading
#Dependencies::RAILS_DEFAULT_LOGGER = Logger.new($stdout)
#Dependencies.log_activity = true

module Airbrush
end

class Object
  def log
    @log ||= Logger.new($stdout)
  end
end
