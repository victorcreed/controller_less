require 'active_support/core_ext'
require 'inherited_resources'

module ControllerLess
  autoload :VERSION, 'controller_less/version'
  autoload :Application, 'controller_less/application'
  autoload :BaseController, 'controller_less/base_controller'
  class << self
     attr_accessor :application
     def application
       @application ||= ControllerLess::Application.new
     end
     def setup
       application.setup!
       yield application
     end
     delegate :register, to: :application
     delegate :load_routes, to: :application
  end
end
