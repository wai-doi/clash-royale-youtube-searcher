require 'rails_helper'

RSpec.describe Batch::VideoItem, type: :model do
  let(:item) do
    # YoutubeAPIレスポンスのオブジェクトのmock
    double('Google::Apis::YoutubeV3::PlaylistItem',
      snippet: double('Google::Apis::YoutubeV3::PlaylistItemSnippet',
        resource_id: double('Google::Apis::YoutubeV3::ResourceId',
          video_id: '11111111'
        ),
        published_at: '2022-01-01T00:00:00Z',
        title: '動画のタイトル',
        description: <<~DESCRIPTION,
          Match details:
          https://statsroyale.com/watch/top200/1645858750_%238J02R29U0_%23GY2UJYP


          EsssBeee
          https://statsroyale.com/profile/GY2UJYP

          deck:
          Bandit, Miner, Mega Knight, Wall Breakers, Bats, Musketeer, Guards, Zap
          https://link.clashroyale.com/deck/en?deck=26000046;26000032;26000055;26000058;26000049;26000014;26000025;28000008


          トレモロ
          https://statsroyale.com/profile/8J02R29U0

          deck:
          Rascals, Dart Goblin, Bats, Fireball, Miner, The Log, Guards, Mortar
          https://link.clashroyale.com/deck/en?deck=26000053;26000040;26000049;28000000;26000032;28000011;26000025;27000002
        DESCRIPTION
        thumbnails: double('Google::Apis::YoutubeV3::ThumbnailDetails',
          medium: double('Google::Apis::YoutubeV3::Thumbnail',
            url: 'https://example.com'
          )
        )
      )
    )
  end

  let(:video_item) { described_class.new(item) }

  describe '#video_id' do
    subject { video_item.video_id }

    it 'video_idを返すこと' do
      expect(subject).to eq '11111111'
    end
  end

  describe '#published_at' do
    subject { video_item.published_at }

    it 'published_atを返すこと' do
      expect(subject).to eq '2022-01-01T00:00:00Z'
    end
  end

  describe '#title' do
    subject { video_item.title }

    it 'titleを返すこと' do
      expect(subject).to eq '動画のタイトル'
    end
  end

  describe '#description' do
    subject { video_item.description }

    it 'descriptionを返すこと' do
      expect(subject).to eq <<~DESCRIPTION
        Match details:
        https://statsroyale.com/watch/top200/1645858750_%238J02R29U0_%23GY2UJYP


        EsssBeee
        https://statsroyale.com/profile/GY2UJYP

        deck:
        Bandit, Miner, Mega Knight, Wall Breakers, Bats, Musketeer, Guards, Zap
        https://link.clashroyale.com/deck/en?deck=26000046;26000032;26000055;26000058;26000049;26000014;26000025;28000008


        トレモロ
        https://statsroyale.com/profile/8J02R29U0

        deck:
        Rascals, Dart Goblin, Bats, Fireball, Miner, The Log, Guards, Mortar
        https://link.clashroyale.com/deck/en?deck=26000053;26000040;26000049;28000000;26000032;28000011;26000025;27000002
      DESCRIPTION
    end
  end

  describe '#thumbnail_url' do
    subject { video_item.thumbnail_url }

    it 'サムネイル画像のURLを返すこと' do
      expect(subject).to eq 'https://example.com'
    end
  end

  describe '#deck_1_cards' do
    subject { video_item.deck_1_cards }

    it 'プレイヤー1のカード名の配列を返すこと' do
      expect(subject).to eq ['Bandit', 'Miner', 'Mega Knight', 'Wall Breakers', 'Bats', 'Musketeer', 'Guards', 'Zap']
    end
  end

  describe '#deck_2_cards' do
    subject { video_item.deck_2_cards }

    it 'プレイヤー2のカード名の配列を返すこと' do
      expect(subject).to eq ['Rascals', 'Dart Goblin', 'Bats', 'Fireball', 'Miner', 'The Log', 'Guards', 'Mortar']
    end
  end
end
