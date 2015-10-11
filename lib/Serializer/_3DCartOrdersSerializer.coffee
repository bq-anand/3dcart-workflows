_ = require "underscore"
_.mixin require "underscore.deep"
Serializer = require "../../core/lib/Serializer"

class _3DCartOrdersSerializer extends Serializer
  constructor: (options) ->
    super

  keymap: ->
    "OrderID": "_uid"

  dateFormat: -> "YYYY-MM-DDTHH:mm:ss"

module.exports = _3DCartOrdersSerializer
