# coding: utf-8
require 'openssl'
require 'json'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/numeric/time'

require 'hmac_auth/version'
require 'hmac_auth/error'
require 'hmac_auth/signature'

module HMACAuth
  mattr_accessor :secret,
    :reject_keys,
    :valid_for

  # The shared secret.
  self.secret = nil

  # Keys to ignore when signing/verifying.
  self.reject_keys = %w(action controller format)

  # Time the signature is valid when verifying
  self.valid_for = 15.minutes

end
