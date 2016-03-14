require 'controller_less/helpers/settings'
require 'controller_less/resource.rb'
require 'controller_less/resources_controller'
require 'controller_less/resource_dsl'

module ControllerLess
  class Application
    include Settings
    include Settings::Inheritance

    setting :load_paths, [Rails.root.join("app", "cls")]
    setting :routes_list, []
    def setup!
      files.each { |file| load(file) }
    end
    def files
      load_paths.flatten.compact.uniq.flat_map { |path| Dir["#{path}/**/*.rb"] }
    end
    def register(name, &block)
      resource = ControllerLess::Resource.new(name)
      unless Object.const_defined?(resource.controller_name)
        eval "class ::#{resource.controller_name} < ControllerLess::ResourcesController; end"
        resource.controller.cl_config = resource
        block_given? && hook_methods(resource, resource.resource_class, &block)
      end
      add_route(name.name.to_s.downcase.pluralize)
    end
    def hook_methods(config, resource_class, &block)
      rdsl = ControllerLess::ResourceDsl.new(config, resource_class)
      rdsl.run_registration_block(&block)
    end
    def add_route(route_name)
      (self.routes_list ||= Array.new).push(route_name)
    end
    def load_routes
      route_reload
    end
    def route_reload
      Rails.application.routes.draw do
        ControllerLess.application.routes_list.each { |route_name| resources(route_name) }
      end
    end
  end
end
