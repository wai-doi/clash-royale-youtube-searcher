class StatsRoyaleVideo < ApplicationRecord
  has_many :matches
  has_many :decks, through: :matches

  validates :youtube_video_id, presence: true, uniqueness: true
  validates :published_at, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :thumbnail_url, presence: true
end
