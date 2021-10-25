class StatsRoyaleVideosController < ApplicationController
  def index
    videos = if params[:card_name]
      StatsRoyaleVideo.includes(decks: :cards).where(decks: { cards: { name: params[:card_name] } })
    else
      StatsRoyaleVideo.all
    end
    @videos = videos.order(published_at: :desc).page(params[:page]).per(10)
    @cards = Card.order(:name)
  end

  def show
    @video = StatsRoyaleVideo.find(params[:id])
  end

  def search_params
    params
  end
end
