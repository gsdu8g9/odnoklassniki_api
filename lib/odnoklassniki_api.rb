$:.push File.expand_path(File.dirname(__FILE__))
require 'odnoklassniki_api/configuration'
require 'odnoklassniki_api/api'
require 'odnoklassniki_api/api_client'

module OdnoklassnikiAPI

  extend Configuration

  class << self
    def new options = {}
      if options.is_a? String
        OdnoklassnikiAPI::Client.new :application_key => options
      elsif options.is_a? Hash
        OdnoklassnikiAPI::Client.new options
      else
        raise ArgumentError
      end
    end
  end

end