require 'rails_helper'
require 'google/apis/youtube_v3'

RSpec.describe Batch::VideoImporter, type: :model do
  before do
    # テストでは標準出力させない
    suppress_puts
  end

  describe "#execute" do
    subject { described_class.new.execute }

    let(:item) do
      # YoutubeAPIレスポンスのオブジェクトのmock
      double(
        'Google::Apis::YoutubeV3::PlaylistItem',
        snippet: double(
          'Google::Apis::YoutubeV3::PlaylistItemSnippet',
          resource_id: double(
            'Google::Apis::YoutubeV3::ResourceId',
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
          thumbnails: double(
            'Google::Apis::YoutubeV3::ThumbnailDetails',
            medium: double(
              'Google::Apis::YoutubeV3::Thumbnail',
              url: 'https://example.com'
            )
          )
        )
      )
    end

    before do
      youtube_client = double('Batch::StatsRoyaleYoutubeClient')
      allow(Batch::StatsRoyaleYoutubeClient).to receive(:new).and_return(youtube_client)
      allow(youtube_client).to receive(:uploaded_video_items).and_return([item])
    end

    context "Cardが保存されてない場合" do
      it "新規のCardが保存されること" do
        expect { subject }.to change { Card.count }.from(0).to(13)

        created_card_names = Card.pluck(:name)
        expect(created_card_names).to match_array(
          [
            'Bandit',
            'Miner',
            'Mega Knight',
            'Wall Breakers',
            'Bats',
            'Musketeer',
            'Guards',
            'Zap',
            'Rascals',
            'Dart Goblin',
            'Fireball',
            'The Log',
            'Mortar'
          ]
        )
      end
    end

    context "Cardが既に保存されている場合" do
      before do
        create(:card, name: 'Bandit')
        create(:card, name: 'Miner')
        create(:card, name: 'Mega Knight')
        create(:card, name: 'Wall Breakers')
        create(:card, name: 'Bats')
        create(:card, name: 'Musketeer')
        create(:card, name: 'Guards')
        create(:card, name: 'Zap')
        create(:card, name: 'Rascals')
        create(:card, name: 'Dart Goblin')
        create(:card, name: 'Fireball')
        create(:card, name: 'The Log')
        create(:card, name: 'Mortar')
      end

      it 'Cardが保存されないこと' do
        expect { subject }.not_to change { Card.count }
      end
    end

    context 'Deckが保存されていない場合' do
      it '新規のDeckが保存されること' do
        expect { subject }.to change { Deck.count }.from(0).to(2)
      end

      it 'DeckにはCardが8枚関連付けられていること' do
        subject

        decks = Deck.all
        expect(decks[0].cards.count).to eq 8
        expect(decks[1].cards.count).to eq 8
      end
    end

    context 'Deckが保存されている場合' do
      before do
        create(:deck, sorted_card_names: 'Bandit,Bats,Guards,Mega Knight,Miner,Musketeer,Wall Breakers,Zap')
        create(:deck, sorted_card_names: 'Bats,Dart Goblin,Fireball,Guards,Miner,Mortar,Rascals,The Log')
      end

      it 'Deckが保存されないこと' do
        expect { subject }.not_to change { Deck.count }
      end
    end


    it "StatsRoyaleVideoが保存されること" do
      expect { subject }.to change { StatsRoyaleVideo.count }.from(0).to(1)
    end

    it "StatsRoyaleVideoにはDeckが2つ関連付けられていること" do
      subject

      video = StatsRoyaleVideo.first
      expect(video.decks.count).to eq 2
    end
  end
end
