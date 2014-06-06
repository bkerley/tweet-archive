class AddGeoPointToTweets < ActiveRecord::Migration
  def change
    enable_extension 'postgis'
    add_column :tweets, :geo_point, 'geography(point, 4326)'

    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET geo_point = ST_MakePoint(
          (json_extract_path(body, 'geo', 'coordinates')->0)::text::decimal,
          (json_extract_path(body, 'geo', 'coordinates')->1)::text::decimal)
        WHERE json_extract_path(body, 'geo', 'coordinates') is not null
      SQL
  end
end
