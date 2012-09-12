require 'rspec'
require 'webmock/rspec'
require 'odnoklassniki_api'
require 'net/http'
require 'pry'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

def stub_get_request(url, body, content_type)
  stub_request(:get, url).to_return(:body => body, :status => 200, :headers => {:content_type => content_type} )
end
