_ = require "underscore"
_.mixin require "underscore.deep"
Serializer = require "../../core/lib/Serializer"

class _3DCartCategoriesSerializer extends Serializer
  constructor: (options) ->
    super

  keymap: ->
    "CategoryID": "_uid"

  dateFormat: -> "YYYY-MM-DDTHH:mm:ss"

module.exports = _3DCartCategoriesSerializer
