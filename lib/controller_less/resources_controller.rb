module ControllerLess
  class ResourcesController < BaseController
    class << self
      attr_accessor :cl_config
    end
    def self.cl_config=(config)
      @cl_config = config
      defaults resource_class: config.resource_class
    end
    def cl_config
      self.class.cl_config
    end
    def self.inherited(base)
      super(base)
      base.override_resource_class_methods!
    end

    def self.override_resource_class_methods!
      class_exec do
        def self.resource_class=(klass); end

        def self.resource_class
          @cl_config ? @cl_config.resource_class : nil
        end

        def resource_class
          self.class.resource_class
        end
      end
    end
  end
end
