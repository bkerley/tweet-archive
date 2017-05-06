require_relative '../config/environment'
require 'set'
require 'pry'

q = Set.new
spooky = Set.new

Tweet.find_each.with_index do |t, i|
  print "\r#{i}"
  q += t.missing_references

  if q.length >= (TWITTER_CLIENT.class::MAX_TWEETS_PER_REQUEST - 10)
    puts "\rfetching #{q.length}"
    begin
      arr = TWITTER_CLIENT.statuses q.to_a
    rescue => e
      binding.pry
    end

    Tweet.transaction do
      arr.each do |api_tweet|
        Tweet.from_api api_tweet
        q.delete api_tweet.id.to_i
      end
    end

    spooky += q
    q.clear
  end
end

arr = TWITTER_CLIENT.statuses q.to_a

Tweet.transaction do
  arr.each do |api_tweet|
    Tweet.from_api api_tweet
    q.delete api_tweet.id.to_i
  end
end

File.open(Rails.root + 'tmp/spooky.txt', 'ashru') do |spooky_txt|
  spooky_txt.write spooky.to_a.join "\n"
end
