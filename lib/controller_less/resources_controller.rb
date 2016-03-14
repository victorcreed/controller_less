module ControllerLess
  class ResourcesController < BaseController
    class << self
      attr_accessor :cl_config
    end
    def self.cl_config=(config)
      @cl_config = config
      self.controller_name = config.controller_name
      self.resource_class = config.resource_class
    end
    def cl_config
      self.class.cl_config
    end
    def self.inherited(base)
      super(base)
      base.override_resource_class_methods!
    end

    def collection
      get_collection_ivar || begin
      collection = find_collection
      set_collection_ivar collection
      end
    end

    def find_collection(options = {})
      collection = scoped_collection
      collection
    end
    def scoped_collection
      end_of_association_chain
    end

    def resource
      get_resource_ivar || begin
      resource = find_resource
      set_resource_ivar resource
      end
    end
    def find_resource
      scoped_collection.send method_for_find, params[:id]
    end

    def self.override_resource_class_methods!
      class_exec do
        def self.resource_class=(klass); end

        def self.resource_class
          @cl_config ? @cl_config.resource_class : nil
        end

        def self.controller_name=(name); end
        def self.controller_name
          @cl_config.try(:controller_name)
        end
        def controller_name
          self.class.controller_name
        end
        def resource_class
          self.class.resource_class
        end
      end
    end
  end
end
