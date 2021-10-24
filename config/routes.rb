Rails.application.routes.draw do
  resources :stats_royale_videos, only: [:index, :show]
end
