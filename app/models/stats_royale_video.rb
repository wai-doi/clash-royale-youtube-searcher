class StatsRoyaleVideo < ApplicationRecord
  EMBED_VIDEO_WIDTH = 1120
  EMBED_VIDEO_HEIGHT = 630
  REMAINING_PERIOD = Rails.configuration.x.remaining_period_for_video

  has_many :matches, dependent: :destroy
  has_many :decks, through: :matches

  validates :youtube_video_id, presence: true, uniqueness: true
  validates :published_at, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :thumbnail_url, presence: true

  scope :old, -> { where(published_at: ..REMAINING_PERIOD.ago) }

  def url
    "https://www.youtube.com/watch?v=#{youtube_video_id}"
  end

  def embed_url
    <<~HTML.squish
      <iframe
        width="#{EMBED_VIDEO_WIDTH}"
        height="#{EMBED_VIDEO_HEIGHT}"
        src="https://www.youtube.com/embed/#{youtube_video_id}"
        title="YouTube video player"
        frameborder="0"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen></iframe>
    HTML
  end

  def formated_published_at
    published_at.strftime("%F %H:%M")
  end
end
