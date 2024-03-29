module Batch
  class VideoItem
    attr_reader :item

    delegate :published_at, to: :snippet
    delegate :title, to: :snippet
    delegate :description, to: :snippet

    def initialize(video_item)
      @item = video_item
    end

    def video_id
      snippet.resource_id.video_id
    end

    def thumbnail_url
      snippet.thumbnails.medium.url
    end

    def deck1_cards
      deck[0]
    end

    def deck2_cards
      deck[1]
    end

    private

    def snippet
      @item.snippet
    end

    def deck
      snippet.description.scan(/deck:\n(.+)\n/).flatten.map { |row_cards| row_cards.split(', ') }
    end
  end
end
