class HomeController < ApplicationController
  def index
    @videos = Video.all.order(:created_at)
  end
end
