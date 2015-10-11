TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartDistributors = require "../../../../Model/_3DCartDistributors"
Serializer = require "../../../../Serializer/_3DCartDistributorsSerializer"

class _3DCartSaveDistributors extends TemporaryTable
  createModel: -> create_3DCartDistributors(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveDistributors
