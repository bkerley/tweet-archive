# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ($) ->
  $('#tweets').on 'click', '.tweet nav p a', (event) ->
    $(event.target).parent().next('ul').toggle()
    event.stopPropagation
