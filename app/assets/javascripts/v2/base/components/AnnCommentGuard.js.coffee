Vue = require "vue"

module.exports = Vue.extend
  props:
    isSpoiler:
      type: Boolean
      default: true
      coerce: (val) ->
        JSON.parse(val)
    comment:
      type: String

  methods:
    remove: ->
      $(@$el).removeClass("ann-comment-guard")

  ready: ->
    $(@$el).addClass("ann-comment-guard") if @isSpoiler
