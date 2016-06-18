module ControllerLess
  class ResourceDsl
    attr_accessor :resource
    def initialize(rs)
      self.resource = rs
    end
    def run_registration_block(&block)
      instance_exec &block
    end
    def controller(&block)
      block_given? && resource.controller.class_exec(&block)
      resource.controller
    end
    def permitted_params(*args, &block)
      p_key = resource.param_key.to_sym
      controller do
        define_method :permitted_params do
          params.permit(p_key => block ? instance_exec(&block) : args)
        end
      end
    end
    def belongs_to(target, options={})
      resource.belongs_to_list.push target
      resource.any_optional_belongs_to || (resource.any_optional_belongs_to = options.fetch(:optional, false))
      resource.controller.send :belongs_to, target, options
    end
    
    def only(args=[])
      resource.routes_options = {only: [args].flatten}
      resource.controller.send :actions, *[args].flatten
    end
  end
end
