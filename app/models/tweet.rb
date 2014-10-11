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

    candidate.extract_retweet_data
    candidate.extract_reply_data

    candidate.save

    if coords = api_tweet.try(:coordinates)
      long, lat = coords[:coordinates]
      stmt = "geo_point = ST_MakePoint(#{long}, #{lat})"
      where(id: candidate.id).
        update_all(stmt)
    elsif api_tweet.try(:place)
      candidate.place_to_geo_point
    end
  end

  def self.in_bbox(bbox)
    # southwest_lng,southwest_lat,northeast_lng,northeast_lat
    sw_lng, sw_lat, ne_lng, ne_lat = bbox.split(',').map(&:to_f)
    box = "ST_MakeBox2D(ST_Point(#{sw_lng}, #{sw_lat}), ST_Point(#{ne_lng}, #{ne_lat}))"
    point = "cast(geo_point as geometry)"
    membership = "#{box} ~ #{point}"

    where(membership)
  end

  def place_to_geo_point
    return if geo_point?
    coords = body['place']['bounding_box']['coordinates'].first rescue return

    coords_args = [coords[0], coords[2]].flatten.map(&:to_f).map(&:to_s).join(', ')

    stmt = "geo_point = ST_Centroid(ST_MakeEnvelope(#{ coords_args }))"

    # points = coords.map{ |(long, lat)| "ST_Point(#{long}, #{lat})" }
    # stmt = "geo_point = ST_Centroid(#{points.join ', '})"
    self.class.where(id: id).update_all(stmt)
  end

  def extract_retweet_data
    return unless body['retweeted_status']
    self.retweeted_status_id = body['retweeted_status_id']
  end

  def extract_reply_data
    return unless body['in_reply_to_status_id']
    self.in_reply_to_status_id = body['in_reply_to_status_id']
  end
end
