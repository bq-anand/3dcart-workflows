_ = require "underscore"
_.mixin require "underscore.deep"
Serializer = require "../../core/lib/Serializer"

class _3DCartProductsSerializer extends Serializer
  constructor: (options) ->
    super

  keymap: -> {}

  dateFormat: -> "YYYY-MM-DDTHH:mm:ss"

  transform: (source, direction) ->
    destination = super
    if direction is "toInternal"
      destination["_uid"] = source["SKUInfo"]["CatalogID"]
    else
      delete destination["_uid"]
    destination

module.exports = _3DCartProductsSerializer
