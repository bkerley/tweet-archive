class UseCoordinatesInsteadOfGeo < ActiveRecord::Migration
  def change
    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET geo_point = ST_MakePoint(
          (json_extract_path(body, 'geo', 'coordinates')->1)::text::decimal,
          (json_extract_path(body, 'geo', 'coordinates')->0)::text::decimal)
        WHERE json_extract_path(body, 'geo', 'coordinates') is not null
      SQL

    Tweet.connection.execute <<-SQL
      UPDATE tweets
        SET geo_point = ST_MakePoint(
          (json_extract_path(body, 'coordinates', 'coordinates')->0)::text::decimal,
          (json_extract_path(body, 'coordinates', 'coordinates')->1)::text::decimal)
        WHERE json_extract_path(body, 'coordinates', 'coordinates') is not null
      SQL
  end
end
