# coding: utf-8
module HMACAuth
  class Signature

    class << self
      def verify(params, options = {})
        self.new(params, options).verify
      end

      def sign(params, options = {})
        self.new(params, options).sign
      end
    end

    def initialize(params, options = {})
      @secret = options.delete(:secret) || HMACAuth.secret
      @valid_for = options.delete(:valid_for) || HMACAuth.valid_for
      @reject_keys = options.delete(:reject_keys) || HMACAuth.reject_keys
      @keep_values_type = options.delete(:keep_values_type) ||
        HMACAuth.keep_values_type
      @_params = params

      raise Error.new 'You *must* tell me a secret!' unless @secret
    end

    def verify
      valid_timestamp && signature == calculated_signature
    end

    # @return [Hash] Signed parameters
    def sign
      timestamp || params['timestamp'] = Time.now.to_i.to_s
      params.merge('signature' => calculated_signature)
    end

    private

      def calculated_signature
        OpenSSL::HMAC.hexdigest(
          OpenSSL::Digest.new('sha256'),
          secret,
          JSON.generate(deep_sort(params_without_signature)))
      end

      def deep_sort(hash)
        Hash[hash.sort.map { |k, v| [k, v.is_a?(Hash) ? deep_sort(v) : v] }]
      end

      def deep_stringify(hash)
        Hash[hash.map do |k, v|
          [k.to_s, v.is_a?(Hash) ? deep_stringify(v) : v.to_s]
        end]
      end

      def deep_stringify_skip_values(hash)
        Hash[hash.map do |k, v|
          [k.to_s, v.is_a?(Hash) ? deep_stringify_skip_values(v) : v]
        end]
      end

      def valid_timestamp
        timestamp && timestamp >= valid_for.ago.to_i
      end

      def timestamp
        params['timestamp'].present? &&
          params['timestamp'].to_s =~ /\A\d+\Z/ &&
          params['timestamp'].to_i
      end

      def signature
        params['signature']
      end

      def params_without_signature
        params.reject { |k, v| k == 'signature' }
      end

      def params
        reject_keys!
        @params ||= if keep_values_type
           deep_stringify_skip_values(reject_keys!)
        else
          deep_stringify(reject_keys!)
        end
      end

      def reject_keys!
        @_params.reject do |k, v|
          reject_keys.include? k
        end
      end

      attr_reader :secret, :valid_for, :reject_keys, :keep_values_type
  end
end
