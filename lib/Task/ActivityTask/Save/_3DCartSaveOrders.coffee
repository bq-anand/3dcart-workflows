UpsertThroughTemporaryTable = require "../../../../core/lib/Task/ActivityTask/Save/UpsertThroughTemporaryTable"
create_3DCartOrders = require "../../../Model/_3DCartOrders"
Serializer = require "../../../_3DCartSerializer"

class _3DCartSaveOrders extends UpsertThroughTemporaryTable
  createModel: -> create_3DCartOrders(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

  insert: (trx, externalObject) ->
    # hack for Bellefit
    if externalObject.InvoiceNumber and externalObject.OrderItemList.length
      super
    else
      false

module.exports = _3DCartSaveOrders
