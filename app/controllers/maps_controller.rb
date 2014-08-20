class MapsController < ApplicationController
  def index
  end

  def show
    @tweets = Tweet.in_bbox params[:bbox]
    
    render json: @tweets.as_json
  end
end
