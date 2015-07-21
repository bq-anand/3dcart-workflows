UpsertThroughTemporaryTable = require "../../../../core/lib/Task/ActivityTask/Save/UpsertThroughTemporaryTable"
createUser = require "../../../Model/Order"
Serializer = require "../../../Serializer"

class SaveOrders extends UpsertThroughTemporaryTable
  createModel: -> createUser(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

  insert: (trx, externalObject) ->
    # hack for Bellefit
    if externalObject.InvoiceNumber and externalObject.OrderItemList.length
      super
    else
      false

module.exports = SaveOrders
