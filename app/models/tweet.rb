class Tweet < ActiveRecord::Base
  default_scope { select('*, ST_X(ST_Transform(cast(geo_point as geometry), 4326)) as long, ST_Y(ST_Transform(cast(geo_point as geometry), 4326)) as lat, ST_AsText(geo_point) as geo_text') }
  scope :newest_first, -> { order(created_at: :desc, id_number: :desc) }

  def latlong
    [lat, long]
  end

  def self.from_api(api_tweet)
    candidate = new
    candidate.id_str = api_tweet.id.to_s
    candidate.text = api_tweet.text
    candidate.body = api_tweet.to_json
    candidate.id_number = api_tweet.id
    candidate.created_at = api_tweet.created_at
    candidate.save
    unless api_tweet.geo.nil?
      stmt = "geo_point = ST_MakePoint(#{api_tweet.geo.lat.to_f}, #{api_tweet.geo.lng.to_f})"
      where(id: candidate.id).
        update_all(stmt)
    end
  end
end
