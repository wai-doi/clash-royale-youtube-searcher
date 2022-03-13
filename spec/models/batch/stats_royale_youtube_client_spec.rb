require 'rails_helper'
require 'google/apis/youtube_v3'

RSpec.describe Batch::StatsRoyaleYoutubeClient, type: :model do
  before do
    # テストでは標準出力させない
    suppress_puts
  end

  describe '#uploaded_video_items' do
    subject { client.uploaded_video_items }

    let(:client) { described_class.new }
    let(:item) { double('item') }

    before do
      stub_const('StatsRoyaleYoutubeClient::YOUTUBE_API_KEY', 'dummy_key')

      youtube_service = Google::Apis::YoutubeV3::YouTubeService.new
      allow(Google::Apis::YoutubeV3::YouTubeService).to receive(:new).and_return(youtube_service)

      list_channels_response = double('list_channels_response')
      dummy_uploads_playlist_id = 'xxxxxx'
      allow(list_channels_response)
        .to receive_message_chain(:items, :first, :content_details, :related_playlists, :uploads)
        .and_return(dummy_uploads_playlist_id)

      allow(youtube_service).to receive(:list_channels).and_return(list_channels_response)


      list_playlist_items_response = double('list_playlist_items_response')

      allow(list_playlist_items_response).to receive(:items).and_return([item])
      allow(list_playlist_items_response).to receive(:next_page_token).and_return(nil)

      allow(youtube_service)
        .to receive(:list_playlist_items).with('snippet', hash_including(playlist_id: dummy_uploads_playlist_id))
        .and_return(list_playlist_items_response)
    end

    it 'アップロード動画のリストが取得できること' do
      expect(subject).to eq([item])
    end
  end
end
