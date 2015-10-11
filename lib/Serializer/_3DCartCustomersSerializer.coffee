_ = require "underscore"
_.mixin require "underscore.deep"
Serializer = require "../../core/lib/Serializer"

class _3DCartCustomersSerializer extends Serializer
  constructor: (options) ->
    super

  keymap: ->
    "CustomerID": "_uid"

  dateFormat: -> "YYYY-MM-DDTHH:mm:ss"

module.exports = _3DCartCustomersSerializer
