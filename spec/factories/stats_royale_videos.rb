FactoryBot.define do
  factory :stats_royale_video do
    youtube_video_id { Faker::Lorem.unique.characters(number: 11) }
    published_at { Time.current }
    title { '動画タイトル' }
    description { '概要欄' }
    thumbnail_url { 'https://example.com' }
  end
end
