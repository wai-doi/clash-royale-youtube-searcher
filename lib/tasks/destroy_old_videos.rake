desc '古い動画を削除する'
task destroy_old_videos: :environment do
  destroyed_videos = StatsRoyaleVideo.old.destroy_all
  puts "#{destroyed_videos.size}件の StatsRoyaleVideo が削除されました"
end
