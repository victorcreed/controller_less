require 'active_support/concern'
module ControllerLess
  module Settings
    extend ActiveSupport::Concern
    included do
      def read_default_settings(name)
        default_setting[name]
      end
      def default_setting
        self.class.default_settings
      end
    end
    class_methods do
      def default_settings
        @default_settings ||= {}
      end

      def setting(name, default)
        default_settings[name] = default
        attr_writer name
        define_method name do 
          if instance_variable_defined? "@#{name}"
            instance_variable_get "@#{name}"
          else
            read_default_settings name
          end
        end
      end
      define_method "#{name}?" do
        value = public_send(name)
        if value.is_a? Array
          value.any?
        else
          value.present?
        end
      end

    end
    module Inheritance

      extend ActiveSupport::Concern
      class_methods do
        def settings_inherited_by(heir)
          (@setting_heirs ||= []) << heir
          heir.send :include, ControllerLess::Settings
        end
        def inheritable_setting(name, default)
          setting name, default
          @setting_heirs.each{ |c| c.setting name, default }
        end

        def deprecated_inheritable_setting(name, default)
          deprecated_setting name, default
          @setting_heirs.each{ |c| c.deprecated_setting name, default }
        end
      end
    end
  end
end
