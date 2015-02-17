require 'openssl'
require 'base64'

def compute_ses_smtp_password(secret_key)
  sha256 = OpenSSL::Digest::Digest.new('sha256')
  message = 'SendRawEmail' # needs to be the string SendRawEmail
  version = "\x02" # needs to be 0x2

  signature = OpenSSL::HMAC.digest(sha256, secret_key, message)
  verSignature = version + signature

  Base64.encode64(verSignature)
end