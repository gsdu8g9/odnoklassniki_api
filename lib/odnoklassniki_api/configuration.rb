require 'logger'
require 'odnoklassniki_api/version'

module OdnoklassnikiAPI
  module Configuration
    VALID_OPTIONS_KEYS = [:endpoint, :user_agent, :adapter, :timeout, :application_key, :logger, :logged_user_id, :api_server, :secret_key, :authorized, :apiconnection, :access_token]

    DEFAULT_ENDPOINT           = 'http://api.odnoklassniki.ru/fb.do'
    DEFAULT_USER_AGENT         = "odnoklassniki_api gem #{OdnoklassnikiAPI::VERSION}".freeze
    DEFAULT_TIMEOUT            = 5
    DEFAULT_ADAPTER            = :net_http
    DEFAULT_APPLICATION_KEY    = nil
    DEFAULT_LOGGER             = Logger.new("log/odnoklassniki_api.log")
    DEFAULT_LOGGED_USER_ID     = nil
    DEFAULT_API_SERVER         = nil
    DEFAULT_SECRET_KEY         = nil
    DEFAULT_AUTHORIZED         = 1
    DEFAULT_APICONNECTION      = nil
    DEFAULT_ACCESS_TOKEN       = nil

    attr_accessor *VALID_OPTIONS_KEYS

    def configure
      yield self
    end

    def self.extended(base)
      base.reset
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each{|k| options[k] = send(k)}
      options
    end

    def reset
      self.adapter            = DEFAULT_ADAPTER
      self.endpoint           = DEFAULT_ENDPOINT
      self.user_agent         = DEFAULT_USER_AGENT
      self.timeout            = DEFAULT_TIMEOUT
      self.application_key    = DEFAULT_APPLICATION_KEY
      self.logger             = DEFAULT_LOGGER
      self.logged_user_id     = DEFAULT_LOGGED_USER_ID
      self.api_server         = DEFAULT_API_SERVER
      self.secret_key         = DEFAULT_SECRET_KEY
      self.authorized         = DEFAULT_AUTHORIZED
      self.apiconnection      = DEFAULT_APICONNECTION
      self.access_token       = DEFAULT_ACCESS_TOKEN
    end

  end
end