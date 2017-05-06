class TweetsController < ApplicationController
  def index
    @title = "Recent Tweets"
    @tweets = Tweet.newest_first.limit(100)
  end

  def search
    @query = params[:q]

    base = Tweet.limit(100)
    begin
      candidate = base.
        where(<<-SQL, q: @query)
          to_tsvector('english', text) @@ to_tsquery('english', :q)
        SQL
      candidate.count
    rescue
      candidate = base.
        where(<<-SQL, q: @query)
          to_tsvector('english', text) @@ plainto_tsquery('english', :q)
        SQL
    end

    @tweets = candidate.newest_first
  end

  def geo
    @tweets = Tweet.
      limit(100).
      where.not(geo_point: nil).
      newest_first
  end

  def around
    @base = Tweet.find params[:id]
    @tweets = Tweet.
      limit(50).
      where('created_at < ?', @base.created_at).
      order(created_at: :desc).reverse
    @tweets += [@base]
    @tweets += Tweet.
      limit(50).
      where('created_at > ?', @base.created_at).
      order(created_at: :asc)
  end

  def show
    id = params[:id]

    if id =~ /^\d+$/
      @tweet = Tweet.find_by id_number: id
    else
      @tweet = Tweet.find_by id: id
    end

    fail ActiveRecord::RecordNotFound unless @tweet
  end

  def populate_references
    @tweet = Tweet.find_by id: params[:id]
    @tweet.populate_missing_references
    redirect_to @tweet
  end

  def census
    @census = Tweet.newest_first.limit(3000).select(:id_str, :created_at)
  end

  def paged_tweet
    Tweet.offset params[:page] * 50
  end
end
