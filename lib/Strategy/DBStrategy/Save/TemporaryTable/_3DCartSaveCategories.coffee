TemporaryTable = require "../../../../../core/lib/Strategy/DBStrategy/Save/TemporaryTable"
create_3DCartCategories = require "../../../../Model/_3DCartCategories"
Serializer = require "../../../../Serializer/_3DCartCategoriesSerializer"

class _3DCartSaveCategories extends TemporaryTable
  createModel: -> create_3DCartCategories(@bookshelf)
  createSerializer: -> new Serializer({model: @model})

module.exports = _3DCartSaveCategories
