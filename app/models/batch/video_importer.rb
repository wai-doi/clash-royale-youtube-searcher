module Batch
  class VideoImporter
    def execute
      require 'dotenv'
      Dotenv.load

      uploaded_video_items = Batch::StatsRoyaleYoutubeClient.new
        .uploaded_video_items
        .map { |item| Batch::VideoItem.new(item) }

      persisted_youtube_video_ids = StatsRoyaleVideo.pluck(:youtube_video_id)
      uploaded_video_items.reject! { |video_item| persisted_youtube_video_ids.include?(video_item.video_id) }

      puts 'Card の保存を開始'
      save_new_cards(uploaded_video_items)
      puts 'Card の保存を終了'

      puts 'StatsRoyaleVideo の保存を開始'
      created_videos = []
      uploaded_video_items.each do |video_item|
        ActiveRecord::Base.transaction do
          # deck作成
          deck1 = save_new_deck(video_item.deck1_cards)
          deck2 = save_new_deck(video_item.deck2_cards)

          # video作成
          created_videos << StatsRoyaleVideo.create!(
            youtube_video_id: video_item.video_id,
            published_at: video_item.published_at,
            title: video_item.title,
            description: video_item.description,
            thumbnail_url: video_item.thumbnail_url,
            decks: [deck1, deck2]
          )
        end
      end
      puts "#{created_videos.size}件の StatsRoyaleVideo の保存を終了"
    end

    private

    def save_new_cards(video_items)
      card_names = video_items.flat_map { |video_item| video_item.deck1_cards + video_item.deck2_cards }.uniq
      new_card_names = card_names - Card.pluck(:name)
      new_card_names.each { |card_name| Card.create!(name: card_name) }
    end

    def save_new_deck(deck_cards)
      sorted_card_names_string = deck_cards.sort.join(',')
      deck = Deck.find_or_initialize_by(sorted_card_names: sorted_card_names_string)
      if deck.new_record?
        deck.cards = Card.where(name: deck_cards)
        deck.save!
      end
      deck
    end
  end
end
