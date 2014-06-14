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
end
