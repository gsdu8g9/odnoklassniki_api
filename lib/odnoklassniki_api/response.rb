module OdnoklassnikiAPI
  class Response
    def initialize(response, options, client)
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
        # @note У нас возникла ситуация, когда на некоторых обновлённых методах ключ пагинации сменился,
        #       а ряд методов остались без изменений.
        #       Для подобных случаев будем проверять оба ключа на наличие, а если они оба отсутствуют, лучше вернём nil,
        #       иначе наши воркеры повисают в попытках получить все 'страницы' ответа
        anchor_hash = nil
        anchor_hash = {pagingAnchor: @response.pagingAnchor} if @response.respond_to?('pagingAnchor')
        anchor_hash = {anchor: @response.anchor} if @response.respond_to?('anchor')
        if anchor_hash != nil
          options = @options.merge(anchor_hash)
          options.delete(:sig)
          result = @client.get(options[:method], options)
        end
      end
      result
    end
  end
end
