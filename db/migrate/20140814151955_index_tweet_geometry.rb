class IndexTweetGeometry < ActiveRecord::Migration
  def change
    Tweet.connection.execute <<-SQL
      CREATE INDEX tweets_geometry 
        ON tweets 
        USING gist (CAST(geo_point AS geometry));
      SQL
  end
end
