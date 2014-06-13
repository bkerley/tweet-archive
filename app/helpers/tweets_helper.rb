module TweetsHelper
  def gmap_url(t)
    coord = t.latlong.join(',')
    key = ENV['GMAPS_KEY']

    "https://maps.googleapis.com/maps/api/staticmap?key=#{key}&center=#{coord}&size=128x128&zoom=13&markers=size:tiny|#{coord}"
  rescue 
    ''
  end

  def mq_url(t)
    coord = t.latlong.join(',')
    key = ENV['MAPQUEST_KEY']

    "http://open.mapquestapi.com/staticmap/v4/getmap?key=#{key}&size=128,128&zoom=13&center=#{coord}&pois=mcenter,#{coord}"  
  rescue 
    ''
  end
end
