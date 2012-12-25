module OdnoklassnikiAPI
  class Response
    def initialize response, options, client
      @response = response
      @options = options
      @client = client
    end

    def response
      @response
    end

    def options
      @options
    end

    def next_page
      result = nil
      if @response.respond_to?('hasMore') && (@response.hasMore)
        options = @options.merge pagingAnchor: @response.pagingAnchor
        options.delete(:sig)
        result = @client.get options[:method], options
      end
      result
    end
  end
end
