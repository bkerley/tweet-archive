class Timeline
  def self.fetch(since=nil)
    if since.nil?
      since = Tweet.newest_first.first.id_number
    end

    arr = TWITTER_CLIENT.user_timeline 'bonzoesc', since_id: since, count: 200

    Tweet.transaction do
      arr.each do |api_tweet|
        Tweet.from_api api_tweet
      end
    end
  end

  def self.fill_range(range_open, range_close)
    count = 0
    loop do
      arr = TWITTER_CLIENT.user_timeline('bonzoesc',
                                         count: 200,
                                         since_id: range_open,
                                         max_id: range_close - 1)

      min_range = range_close + 1
      Tweet.transaction do
        arr.each do |api_tweet|
          Tweet.from_api api_tweet

          if api_tweet.id < min_range
            min_range = api_tweet.id.to_i
          end
        end
      end

      count += 1

      if arr.length < 190
        p arr.length
        return count
      end

      range_close = min_range
      sleep 1
    end
  end
end
