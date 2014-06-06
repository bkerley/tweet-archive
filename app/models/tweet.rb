class Tweet < ActiveRecord::Base
  default_scope { select('*, ST_AsText(geo_point) as geo_text') }

  def latlong
    md = /(-?[\d.]+) (-?[\d.]+)/.match geo_text
    [md[1], md[2]]
  end
end
