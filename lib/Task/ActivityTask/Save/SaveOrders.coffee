UpsertThroughTemporaryTable = require "../../../../core/lib/Task/ActivityTask/Save/UpsertThroughTemporaryTable"
createUser = require "../../../Model/Order"
Serializer = require "../../../Serializer"

class SaveOrders extends UpsertThroughTemporaryTable
  createModel: -> createUser(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = SaveOrders
