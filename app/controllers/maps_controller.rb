class MapsController < ApplicationController
  def index
  end

  def show
    @tweets = Tweet.in_bbox(params[:bbox]).limit(100).as_json.map do |t|
      t['link'] = tweet_path(t['id'])
      t
    end
    @counter = Tweet.unscoped.in_bbox(params[:bbox]).count
    
    json = { 
      tweets: @tweets,
      count: @counter
    }

    render json: json
  end
end
