require 'r509/cert/extensions/base'

module R509
  class Cert
    module Extensions
      # RFC 5280 Description (see: http://www.ietf.org/rfc/rfc5280.txt)
      #
      # The subject key identifier extension provides a means of identifying
      # certificates that contain a particular public key.
      #
      # You can use this extension to parse an existing extension for easy access
      # to the contents or create a new one.
      class SubjectKeyIdentifier < OpenSSL::X509::Extension
        include R509::ValidationMixin

        # friendly name for Subject Key Identifier OID
        OID = "subjectKeyIdentifier"
        # default extension behavior when generating
        SKI_EXTENSION_DEFAULT = "hash"
        Extensions.register_class(self)

        # This method takes a hash or an existing Extension object to parse
        # @option arg :public_key [OpenSSL::PKey] (Cert/CSR/PrivateKey return this type from #public_key)
        # @option arg :critical [Boolean] (false)
        def initialize(arg)
          if arg.kind_of?(Hash)
            validate_subject_key_identifier(arg)
            ef = OpenSSL::X509::ExtensionFactory.new
            cert = OpenSSL::X509::Certificate.new
            cert.public_key = arg[:public_key]
            ef.subject_certificate = cert
            critical = R509::Cert::Extensions.calculate_critical(arg[:critical], false)
            arg = ef.create_extension("subjectKeyIdentifier", SKI_EXTENSION_DEFAULT, critical)
          end
          super(arg)
        end

        # @return value of key
        def key
          return self.value
        end
      end
    end
  end
end