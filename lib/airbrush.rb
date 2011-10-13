$:.unshift File.dirname(__FILE__)

# required gems
require 'active_support'
require 'active_support/dependencies'
require 'active_support/time'
require 'active_support/core_ext'


# for the moment lets log dependency loading
#Dependencies::RAILS_DEFAULT_LOGGER = Logger.new($stdout)
#Dependencies.log_activity = true

module Airbrush
end


