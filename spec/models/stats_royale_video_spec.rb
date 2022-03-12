require 'rails_helper'

RSpec.describe StatsRoyaleVideo, type: :model do
  describe '.old' do
    subject { described_class.old }

    let!(:older_video) { create(:stats_royale_video, published_at: 1.week.ago) }
    let!(:newer_video) { create(:stats_royale_video, published_at: Time.current.ago(1.weeks - 1.minutes)) }

    it "一週間前のレコードが含まれること" do
      expect(subject).to include older_video
    end

    it "一週間以内のレコードは含まれないこと" do
      expect(subject).not_to include newer_video
    end
  end
end
