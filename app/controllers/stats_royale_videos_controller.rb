class StatsRoyaleVideosController < ApplicationController
  def index
    @videos = StatsRoyaleVideo.all
  end

  def show
  end
end
