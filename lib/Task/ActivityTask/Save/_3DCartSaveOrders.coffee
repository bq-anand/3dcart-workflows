UpsertThroughTemporaryTable = require "../../../../core/lib/Task/ActivityTask/Save/UpsertThroughTemporaryTable"
createUser = require "../../../Model/_3DCartOrder"
Serializer = require "../../../_3DCartSerializer"

class _3DCartSaveOrders extends UpsertThroughTemporaryTable
  createModel: -> createUser(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

  insert: (trx, externalObject) ->
    # hack for Bellefit
    if externalObject.InvoiceNumber and externalObject.OrderItemList.length
      super
    else
      false

module.exports = _3DCartSaveOrders
