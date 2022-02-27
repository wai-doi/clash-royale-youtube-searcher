desc '新しい動画をDBに保存する'
task import_new_videos: [:environment, :destroy_old_videos] do
  Batch::VideoImporter.new.execute
end
