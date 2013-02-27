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
      elsif @response.is_a?(Hash) && @response['offset'] && @response['totalCount']
        collection_key = @response.keys.detect{ |k| @response[k].is_a?(Array) }
        new_offset = @response[collection_key].size + @response['offset']

        if new_offset < @response['totalCount']
          options = @options.merge offset: new_offset
          options.delete(:sig)
          result = @client.get options[:method], options
        end
      end

      result
    end
  end
end
