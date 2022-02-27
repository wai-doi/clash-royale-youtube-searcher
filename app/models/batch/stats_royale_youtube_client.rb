require 'google/apis/youtube_v3'

module Batch
  class StatsRoyaleYoutubeClient
    YOUTUBE_API_KEY = ENV['YOUTUBE_API_KEY']
    CHANNEL_ID = 'UC698QxCg2KVVWh4G6NQLX_w'
    REQUEST_COUNT_LIMIT = 100
    PLAYLIST_ITEM_COUNT_PER_REQUEST = 50 # 最大50まで設定できる
    VIDEO_REQUEST_TERM = 1.month

    def initialize
      @youtube_service = Google::Apis::YoutubeV3::YouTubeService.new
      @youtube_service.key = YOUTUBE_API_KEY
    end

    def uploaded_video_items
      uploads_playlist_id
      uploaded_video_items = []
      next_page_token = nil

      REQUEST_COUNT_LIMIT.times do
        response = @youtube_service.list_playlist_items('snippet', playlist_id: uploads_playlist_id, max_results: PLAYLIST_ITEM_COUNT_PER_REQUEST, page_token: next_page_token)
        uploaded_video_items += response.items

        Rails.logger.info("#{uploaded_video_items.size} 件取得")

        next_page_token = response.next_page_token
        break if next_page_token.nil? || response.items.any? { |item| Time.zone.parse(item.snippet.published_at) < VIDEO_REQUEST_TERM.ago }

        sleep 0.1
      end

      uploaded_video_items
    end

    private

    # APIからチャンネルの基本情報を取得して、アップロードプレイリストのIDを取得する
    def uploads_playlist_id
      response = @youtube_service.list_channels('contentDetails', id: CHANNEL_ID)
      response.items.first.content_details.related_playlists.uploads
    end
  end
end
