require 'odnoklassniki_api/connection'
require 'odnoklassniki_api/configuration'
require 'odnoklassniki_api/request'
require 'odnoklassniki_api/errors'

module OdnoklassnikiAPI
  class Api
    include Connection
    include Request

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize options = {}
      options = OdnoklassnikiAPI.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end