require 'timeout'
require 'faraday_middleware'
require 'faraday'
require 'odnoklassniki_api/errors'
require 'odnoklassniki_api/connection'
require 'digest/md5'
require 'multi_json'
require 'odnoklassniki_api/response'

module OdnoklassnikiAPI
  module Request
    MAX_TRIES = 3

    def get api_method, options = {}
      request(api_method, options)
    end

    private

    def calculate_signature options
      signature = String.new('')
      secret_string = options[:access_token].to_s + secret_key.to_s
      secret_hash = Digest::MD5.hexdigest(secret_string)
      options = options.sort
      options.each do |key, value|
        if (key != :access_token)
          signature += key.to_s + "=" + value.to_s
        end
      end
      signature = (signature + secret_hash)
      Digest::MD5.hexdigest(signature)
    end

    def request(api_method, options)
      options = options.merge method: api_method
      options = options.merge application_key: application_key
      options = options.merge access_token: access_token
      signature = calculate_signature options
      options = options.merge sig: signature
      response = get_data options
    end

    def get_data options, try_no = 0
      raise OdnoklassnikiAPI::Error::TimeoutError, "Timeout error" unless try_no < MAX_TRIES

      begin
        response = connection.get { |request| request.params = options }
        raise OdnoklassnikiAPI::Error::WrongStatusError, "HTTP response code #{response.status}" unless response.status == 200
        response = response.body

        if response.respond_to? :error_code
          raise Error::ApiError.get_by_code response.error_code.to_s
        end
        OdnoklassnikiAPI::Response.new response, options, self

      rescue MultiJson::DecodeError => e
        raise OdnoklassnikiAPI::Error::ParsingError, "MultiJson decode error"
      rescue Faraday::Error::TimeoutError => e
        raise OdnoklassnikiAPI::Error::TimeoutError, "Timeout error"
      rescue Faraday::Error::ParsingError => e
        raise OdnoklassnikiAPI::Error::ParsingError, "Faraday parsing error"
      rescue Errno::ETIMEDOUT => e
        get_data options, try_no + 1
      end
    end

  end
end
