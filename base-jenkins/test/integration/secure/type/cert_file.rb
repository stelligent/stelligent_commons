#-x509 -nodes -days 365 -newkey rsa:2048 -subj '#{node[:jenkins][:cert_subject]}'

module Serverspec
  module Type
    class CertFile < Base
      def initialize(location)
        @location = location

        @content = IO.read location
      end

      def x509?
        begin
          OpenSSL::X509::Certificate.new @content
        rescue Error
          false
        end
        true
      end

      def subject?(name)
        certificate = OpenSSL::X509::Certificate.new IO.read @location
        certificate.subject.to_s == name
      end

      def to_s
        @location
      end
    end

    def cert_file(location)
      CertFile.new(location)
    end
  end
end

include Serverspec::Type