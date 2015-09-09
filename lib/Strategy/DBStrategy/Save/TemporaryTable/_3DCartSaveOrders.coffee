TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartOrders = require "../../../../Model/_3DCartOrders"
Serializer = require "../../../../_3DCartSerializer"

class _3DCartSaveOrders extends TemporaryTable
  createModel: -> create_3DCartOrders(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveOrders
