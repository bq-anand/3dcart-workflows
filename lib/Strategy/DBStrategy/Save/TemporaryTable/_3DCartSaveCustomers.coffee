TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartCustomers = require "../../../../Model/_3DCartCustomers"
Serializer = require "../../../../Serializer/_3DCartCustomersSerializer"

class _3DCartSaveCustomers extends TemporaryTable
  createModel: -> create_3DCartCustomers(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveCustomers
