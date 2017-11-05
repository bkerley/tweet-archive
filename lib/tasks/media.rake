namespace :media do
  desc 'import twitpic media'
  task :twitpic => :environment do
    Dir.glob('/Users/bkerley/Sync/twitpic/user-export-2730079ca98221a2d563fd7d8f964fee/*.jpg').each do |jpeg|
      basename = File.basename jpeg, '.jpg'
      url = "http://twitpic.com/#{basename}"
      json = [{ "expanded_url" => url }].to_json
      tweet = Tweet.where("body->'entities'->'urls' @> ?", json).first
      attachment = Attachment.new tweet: tweet, index: 1
      attachment.file = File.open jpeg
      attachment.save
      p basename
    end
  end
end
