require 'timeout'
require 'faraday_middleware'
require 'faraday'
require 'odnoklassniki_api/errors'
require 'odnoklassniki_api/connection'
require 'digest/md5'
require 'multi_json'

module OdnoklassnikiAPI
  module Request

    def get api_method, options = {}
      request(api_method, options)
    end

    def get_next_page response
      get_next_page_data response
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

      response.instance_eval <<-RESP
        def options; #{options} end
      RESP

    response
    end

    def get_data options
      begin
        response = connection.get { |request| request.params = options }

        response_error = (response.status != 200) ? OdnoklassnikiAPI::Error::WrongStatusError : nil

      rescue MultiJson::DecodeError => e
        response_error = OdnoklassnikiAPI::Error::ParsingError
      rescue Faraday::Error::TimeoutError => e
        response_error = Faraday::Error::TimeoutError
      rescue Faraday::Error::ParsingError => e
        response_error = OdnoklassnikiAPI::Error::ParsingError
      end

      if !response_error.nil?
        response = response_error
      else
        response = response.body

        if response.respond_to? :error_code
          response = Error::ApiError.get_by_code response.error_code.to_s
        end
      end

      response
    end

    def get_next_page_data response
      result = nil
      if response.respond_to?('hasMore') && (response.hasMore)
        options = response.options
        options.delete(:sig)
        options = options.merge pagingAnchor: response.pagingAnchor
        signature =  calculate_signature options
        options = options.merge sig: signature

        result = get_data options
      end

      result
    end

  end
end
