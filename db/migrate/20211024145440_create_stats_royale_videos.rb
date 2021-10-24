class CreateStatsRoyaleVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :stats_royale_videos do |t|
      t.string :youtube_video_id, null: false
      t.datetime :published_at, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :thumbnail_url, null: false

      t.timestamps
    end

    add_index :stats_royale_videos, :youtube_video_id, unique: true
  end
end
