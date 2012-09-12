require 'faraday_middleware'

module OdnoklassnikiAPI
  module Connection
    private

    def connection
      options = {
          :headers => {
              :user_agent => user_agent,
              :content_type => 'application/json'
          },
          :url => endpoint
      }

      Faraday.new options do |builder|
        builder.use Faraday::Request::UrlEncoded

        builder.use Faraday::Response::Mashify
        builder.use Faraday::Response::ParseJson

        builder.response :logger

        builder.adapter(adapter)
      end
    end
  end
end