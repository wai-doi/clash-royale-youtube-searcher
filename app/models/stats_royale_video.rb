class StatsRoyaleVideo < ApplicationRecord
  CHANNEL_ID = "UC698QxCg2KVVWh4G6NQLX_w"
  EMBED_VIDEO_WIDTH = 1120
  EMBED_VIDEO_HEIGHT = 630

  has_many :matches
  has_many :decks, through: :matches

  validates :youtube_video_id, presence: true, uniqueness: true
  validates :published_at, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :thumbnail_url, presence: true

  def url
    "https://www.youtube.com/watch?v=#{youtube_video_id}"
  end

  def embed_url
    %Q(<iframe width="#{EMBED_VIDEO_WIDTH}" height="#{EMBED_VIDEO_HEIGHT}" src="https://www.youtube.com/embed/#{youtube_video_id}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>)
  end

  def formated_published_at
    published_at.strftime("%F %H:%M")
  end
end
