desc "一ヶ月前の動画を削除する"
task destroy_old_videos: :environment do
  StatsRoyaleVideo.where(published_at: ..1.month.ago).destroy_all
end
