module ControllerLess
  class Resource
    attr_accessor :resource_class_name, :options
    def initialize(rc, opt={})
      self.resource_class_name, self.options = "::#{rc.name}", opt
    end
    def resource_name
      resource_class
    end
    def route_name
      resource_class.name.underscore.pluralize
    end
    def resource_class
      resource_class_name.constantize
    end
    def controller_name
      controller_namespace + resource_name.name.pluralize.camelize + "Controller"
    end
    def controller_namespace
      if namespace.present?
        str = ""
        (arry = namespace.split("::")).each_with_index do |val, index|
          str += ";module #{ index == 0 && "::" || "" }#{val}"
        end
        str << ";end" * arry.size
        eval(str)
        @namespace_name ||= namespace << "::"
      else
        ""
      end
    end
    def namespace
      options.fetch(:namespace, "")
    end
    def route
      namespace_route || simple_route
    end
    def namespace_route
      namespace.present? && build_namespace_route || nil
    end
    def build_namespace_route
      func  = "lambda do;"
      arry = options.fetch(:namespace).split("::")
      func += arry.map { |val| "namespace(:#{val.downcase}) do" }.join(";") << (";#{  belongs_to_or_simple_route }" + ";end" * arry.size + ";end")
      @build_namespace_route = eval(func)
    end
    def simple_route
      belongs_to_list.present? && build_nested_routes_func || [:resources, route_name.to_sym]
    end
    def build_nested_routes_func
      eval("lambda do; #{build_nested_routes};end")
    end
    def build_nested_routes
      @build_nested_routes = belongs_to_list.map { |val| "resources(:#{val.to_s.pluralize}) do" }.join(";") << (";#{nested_route}" + ";end;" * belongs_to_list.size)
      any_optional_belongs_to && @build_nested_routes << nested_route
      @build_nested_routes
    end
    def belongs_to_or_simple_route
      belongs_to_list.present? && build_nested_routes || nested_route
    end
    def nested_route
      "resources '#{route_name}'"
    end
    def controller
      @controller ||= controller_name.constantize
    end
    def any_optional_belongs_to=(value)
      @any_optional_belongs_to = value
    end
    def any_optional_belongs_to
      @any_optional_belongs_to ||= false
    end
    def belongs_to_list
      @belongs_to_list ||= Array.new
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
