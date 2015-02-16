module Serverspec
  module Type
    class ApacheModule < Base
      def initialize(module_name)
        @module_name = module_name
      end

      def installed_to_apache?
        module_list = `apache2ctl -M | grep #{@module_name}`
        puts module_list
        if (module_list =~ /#{@module_name}/) == nil
          false
        else
          true
        end
      end

      def to_s
        @module_name
      end
    end

    def apache_module(module_name)
      ApacheModule.new(module_name)
    end
  end
end

include Serverspec::Type