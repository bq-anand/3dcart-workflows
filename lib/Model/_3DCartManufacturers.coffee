_ = require "underscore"
helper = require "../../core/helper/model"

module.exports = (bookshelf) ->
  bookshelf.Model.extend
    tableName: "_3DCartManufacturers"
    hasTimestamps: ['_createdAt', '_updatedAt']
  ,
    _.extend helper(bookshelf),
      buildTable: (table) ->
        table.increments()
        table.string("ManufacturerName").notNullable()
        table.string("Logo").nullable()
        table.integer("Sorting").nullable()
        table.text("Header").nullable()
        table.string("Website").nullable()
        table.string("UserID").nullable()
        table.dateTime("LastUpdate").notNullable()
        table.string("PageTitle").nullable()
        table.text("MetaTags").nullable()
        table.string("RedirectURL").nullable()

        table.bigInteger("_uid").notNullable().unsigned() # native 3DCart id
        table.string("_avatarId").notNullable()
        table.dateTime("_createdAt").notNullable()
        table.dateTime("_updatedAt").notNullable()
        table.unique(["_uid", "_avatarId"], "_3dcartmanufacturers__uid__avatarid_unique") # index name is optional; it's added here as workaround for a number "3" in the beginning of index name
