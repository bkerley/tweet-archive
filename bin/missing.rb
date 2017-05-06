require_relative '../config/environment'

require 'set'
require 'csv'
require 'pp'

missing = Set.new

CSV.foreach ARGV[0] do |r|
  id = r.first.to_i
  next if 0 == id
  found = Tweet.find_by id_number: id

  next if found
  missing.add id
end

puts "missing #{missing.length}"

exit 0 if missing.empty?

loop do
  arr = TWITTER_CLIENT.statuses missing.to_a

  Tweet.transaction do
    arr.each do |api_tweet|
      Tweet.from_api api_tweet
      missing.delete api_tweet.id.to_i
    end
  end

  puts "added #{arr.length}"

  exit 0 if missing.empty?

  sleep 1
end
