class TweetsController < ApplicationController
  def index
    @tweets = Tweet.limit(100).order(created_at: :desc, id_number: :desc)
  end

  def show
    @tweet = Tweet.find_by id_number: params[:id]
  end
end
