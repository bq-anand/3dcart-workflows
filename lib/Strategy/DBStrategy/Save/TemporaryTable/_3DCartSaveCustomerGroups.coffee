TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartCustomerGroups = require "../../../../Model/_3DCartCustomerGroups"
Serializer = require "../../../../Serializer/_3DCartCustomerGroupsSerializer"

class _3DCartSaveCustomerGroups extends TemporaryTable
  createModel: -> create_3DCartCustomerGroups(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveCustomerGroups
