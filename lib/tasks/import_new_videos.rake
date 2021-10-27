desc '新しい動画をDBに保存する'
task import_new_videos: [:environment, :destroy_old_videos] do
  require 'dotenv'
  require 'google/apis/youtube_v3'
  Dotenv.load

  youtube = Google::Apis::YoutubeV3::YouTubeService.new
  youtube.key = ENV["YOUTUBE_API_KEY"]

  response = youtube.list_channels('contentDetails', id: StatsRoyaleVideo::CHANNEL_ID)
  uploads_playlist_id = response.items.first.content_details.related_playlists.uploads

  uploaded_video_items = []
  next_page_token = nil

  100.times do
    response = youtube.list_playlist_items('snippet', playlist_id: uploads_playlist_id, max_results: 50, page_token: next_page_token)
    uploaded_video_items += response.items
    puts "#{uploaded_video_items.size} 件取得"
    next_page_token = response.next_page_token
    break if next_page_token.nil? || response.items.any? { |item| Time.zone.parse(item.snippet.published_at) < 1.month.ago }
    sleep 0.1
  end

  parsed_videos = uploaded_video_items
    .map(&:snippet)
    .map { |snippet|
      deck = snippet.description.scan(/deck:\n(.+)\n/).flatten.map { |row_cards| row_cards.split(', ') }
      {
        video_id: snippet.resource_id.video_id,
        published_at: snippet.published_at,
        title: snippet.title,
        description: snippet.description,
        thumbnail_url: snippet.thumbnails.medium.url,
        deck_1_cards: deck[0],
        deck_2_cards: deck[1],
      }
    }

  persisted_youtube_video_ids = StatsRoyaleVideo.pluck(:youtube_video_id)
  parsed_videos.reject! { |parsed_video| persisted_youtube_video_ids.include?(parsed_video[:video_id]) }

  puts "Card の保存を開始"
  save_new_cards(parsed_videos)
  puts "Card の保存を終了"

  puts "StatsRoyaleVideo の保存を開始"
  created_videos = []
  parsed_videos.each do |parsed_video|
    ActiveRecord::Base.transaction do
      # deck作成
      deck_1 = save_new_deck(parsed_video[:deck_1_cards])
      deck_2 = save_new_deck(parsed_video[:deck_2_cards])

      # video作成
      created_videos << StatsRoyaleVideo.create!(
        youtube_video_id: parsed_video[:video_id],
        published_at: parsed_video[:published_at],
        title: parsed_video[:title],
        description: parsed_video[:description],
        thumbnail_url: parsed_video[:thumbnail_url],
        decks: [deck_1, deck_2]
      )
    end
  end
  puts "#{created_videos.size}件の StatsRoyaleVideo の保存を終了"
end

def save_new_cards(parsed_videos)
  card_names = parsed_videos.flat_map { |parsed_video| parsed_video[:deck_1_cards] + parsed_video[:deck_2_cards] }.uniq
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
