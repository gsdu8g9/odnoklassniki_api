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
      options = OdnoklassnikiAPI.options.merge(prepare_options options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    private
    def prepare_options options
      options_tmp = Hash.new
      options.each do |key, value|
        if Configuration::VALID_OPTIONS_KEYS.include? key.to_sym
          options_tmp.store(key.to_sym, value)
        end
      end
      options_tmp
    end
  end
end