# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # List view: convert raw timestamps to human-readable local time
  $('.timestring').each ->
    @textContent = moment.utc(@textContent).local().calendar()
