module TweetsHelper
  def gmap_url(t)
    coord = t.latlong.join(',')
    key = ENV['GMAPS_KEY']

    "https://maps.googleapis.com/maps/api/staticmap?key=#{key}&center=#{coord}&size=128x128&zoom=13&markers=size:tiny|#{coord}"
  end
end
