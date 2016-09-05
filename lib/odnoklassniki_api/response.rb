module OdnoklassnikiAPI
  class Response
    # список сущностей, которые в ответе могут быть пагинируемыми
    ENTITIES = %w(photos groups comments albums discussions)

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
      # Из-за того, что некоторые методы работают по-старому (с hasMore и на последней странице по анкору начинают слать себя же),
      # нужно отдельно проверять случаи, когда hasMore нет, но next_page брать нужно.
      # Поэтому, сначала проверяем наличие ключа hasMore, и если его нет, проверяем по новой схеме пагинации, где вычисляем, последняя ли это была страница.
      non_last_page = !was_last_page?
      if has_more? || non_last_page
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
      # в пришедшей новой странице может оказаться nil внутри, поэтому возвращаем nil сразу для единообразя
      if non_last_page && result!=nil && result.response!=nil
        ENTITIES.each do |entity|
          return nil if result.response.respond_to?(entity) && result.response[entity]==nil
        end
      end
      result
    end

    private
    def has_more?
      @response.respond_to?('hasMore') && (@response.hasMore)
    end

    def was_last_page?
      # если в опциях есть count и количество возвращаемых результатов меньше count, считаем, что страница была последней.
      # если count не задан или количество вернувшихся записей в ответе равно nil, считаем, что страница была последней.
      count = @options[:count] || @options["count"] if @options
      items_count = nil
      if @response
        ENTITIES.each { |entity| items_count = @response[entity].size and break if @response.respond_to?(entity) && @response[entity]!=nil }
      end
      if count==nil || items_count==nil
        true
      else
        count > items_count
      end
    end
  end
end
