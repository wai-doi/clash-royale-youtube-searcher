module Batch
  class VideoItem
    attr_reader :item

    def initialize(video_item)
      @item = video_item
    end

    def snippet
      @item.snippet
    end

    def video_id
      snippet.resource_id.video_id
    end

    def published_at
      snippet.published_at
    end

    def title
      snippet.title
    end

    def description
      snippet.thumbnails.medium.url
    end

    def thumbnail_url
      snippet.thumbnails
    end

    def deck_1_cards
      deck[0]
    end

    def deck_2_cards
      deck[1]
    end

    private

    def deck
      snippet.description.scan(/deck:\n(.+)\n/).flatten.map { |row_cards| row_cards.split(', ') }
    end
  end
end
