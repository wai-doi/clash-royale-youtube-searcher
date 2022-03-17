Rails.application.routes.draw do
  root 'stats_royale_videos#index'
  resources :stats_royale_videos, only: %i[index show]
end
