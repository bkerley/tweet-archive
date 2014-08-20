class TweetsController < ApplicationController
  def index
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
  end
end
