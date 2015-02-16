module Serverspec
  module Type
    class ApacheSite < Base
      def initialize(site_name)
        @site_name = site_name
      end

      def enabled?
        ::File.exist? "/etc/apache2/sites-enabled/#{@site_name}.conf"
      end

      def to_s
        @site_name
      end
    end

    def apache_site(site_name)
      ApacheSite.new(site_name)
    end
  end
end

include Serverspec::Type