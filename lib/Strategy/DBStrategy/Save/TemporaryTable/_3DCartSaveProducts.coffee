TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartProducts = require "../../../../Model/_3DCartProducts"
Serializer = require "../../../../Serializer/_3DCartProductsSerializer"

class _3DCartSaveProducts extends TemporaryTable
  createModel: -> create_3DCartProducts(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveProducts
