module ControllerLess
  class Resource
    attr_accessor :resource_class_name, :options
    def initialize(rc, opt={})
      self.resource_class_name, self.options = "::#{rc.name}", opt
    end
    def resource_name
      resource_class
    end
    def resource_class
      resource_class_name.constantize
    end
    def controller_name
      resource_name.name.pluralize.camelize + "Controller"
    end
    def controller
      @controller ||= controller_name.constantize
    end

    def param_key
      if resource_class.respond_to? :model_name
        resource_class.model_name.param_key
      else
        resource_name.param_key
      end
    end
  end
end
