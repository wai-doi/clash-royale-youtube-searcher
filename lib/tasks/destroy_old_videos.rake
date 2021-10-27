desc "一ヶ月前の動画を削除する"
task destroy_old_videos: :environment do
  destroyed_videos = StatsRoyaleVideo.where(published_at: ..1.month.ago).destroy_all
  puts "#{destroyed_videos.size}件の StatsRoyaleVideo が削除されました"
end
