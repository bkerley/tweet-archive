jQuery ($) ->
  return unless $('#leaflet').length > 0

  mapElement = $('#leaflet')
  updateUrl = mapElement.data 'update-url'

  map = L.map 'leaflet',
    center: [28.1,-81.6],
    zoom: 5
    layers: MQ.mapLayer()

  class MapUpdater
    constructor: ->
      @markers = []
    updateBounds: (event) =>
      bounds = map.getBounds()
      $.ajax
        url: @urlForBounds(bounds)
        dataType: 'json'
        method: 'get'
        success: @showTweets
    showTweets: (data, status, jqx) =>
      for marker in @markers
        map.removeLayer marker
      @markers = for tweet in data
        marker = L.marker [tweet.lat, tweet.long],
          title: tweet.text

        marker.addTo map
    urlForBounds: (bounds) ->
      updateUrl.replace /_$/, bounds.toBBoxString()

  updater = new MapUpdater

  map.on 'moveend', updater.updateBounds
