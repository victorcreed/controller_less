module ControllerLess
  class ResourceDsl
    attr_accessor :config, :resource_class
    def initialize(conf, rclass)
      self.config, self.resource_class = conf, rclass
    end
     def run_registration_block(&block)
       instance_exec &block
     end
     def controller(&block)
        block_given? && config.controller.class_exec(&block)
        config.controller
     end
     def permitted_params(*args, &block)
       param_key = config.param_key.to_sym
       controller do
          define_method :permitted_params do
            params.permit(param_key => block ? instance_exec(&block) : args)
          end
       end
     end
  end
end
