class TweetsController < ApplicationController
  def index
    @tweets = Tweet.
      limit(100).
      order(created_at: :desc, id_number: :desc)
  end

  def search
    @query = params[:q]

    begin
      @tweets = Tweet.
        limit(100).
        where(<<-SQL, q: @query).
          to_tsvector('english', text) @@ to_tsquery('english', :q)
        SQL
        order(created_at: :desc, id_number: :desc)
      @tweets.count
    rescue
      @tweets = Tweet.
        limit(100).
        where(<<-SQL, q: @query).
          to_tsvector('english', text) @@ plainto_tsquery('english', :q)
        SQL
        order(created_at: :desc, id_number: :desc)
    end
  end

  def geo
    @tweets = Tweet.
      limit(100).
      where.not(geo_point: nil).
      order(created_at: :desc, id_number: :desc)
  end

  def show
    id = params[:id]

    if id =~ /^\d+$/
      @tweet = Tweet.find_by id_number: id
    else
      @tweet = Tweet.find_by id: id
    end
  end
end
