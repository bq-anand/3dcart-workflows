_ = require "underscore"
_.mixin require "underscore.deep"
BaseSerializer = require "../core/lib/Serializer"

class Serializer extends BaseSerializer
  constructor: (options) ->
    super

  keymap: ->
    "OrderID": "_uid"

  dateFormat: -> "YYYY-MM-DDTHH:mm:ss"

module.exports = Serializer
