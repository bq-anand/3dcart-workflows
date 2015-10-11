TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartManufacturers = require "../../../../Model/_3DCartManufacturers"
Serializer = require "../../../../Serializer/_3DCartManufacturersSerializer"

class _3DCartSaveManufacturers extends TemporaryTable
  createModel: -> create_3DCartManufacturers(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveManufacturers
