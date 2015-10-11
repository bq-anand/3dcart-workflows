_ = require "underscore"
helper = require "../../core/helper/model"

module.exports = (bookshelf) ->
  bookshelf.Model.extend
    tableName: "_3DCartDistributors"
    hasTimestamps: ['_createdAt', '_updatedAt']
  ,
    _.extend helper(bookshelf),
      buildTable: (table) ->
        table.increments()
        table.string("CompanyName").notNullable()
        table.string("ContactName").notNullable()
        table.string("Address").nullable()
        table.string("Address2").nullable()
        table.string("City").nullable()
        table.string("State").nullable()
        table.string("Zip").nullable()
        table.string("Country").nullable()
        table.string("Phone").nullable()
        table.string("Fax").nullable()
        table.string("Email").nullable()
        table.text("Comments").nullable()
        table.boolean("NotifyOnNewOrder").nullable()
        table.string("NotifyOnNewOrderEmailSubject").nullable()
        table.text("NotifyOnNewOrderEmailMessage").nullable()
        table.string("UserID").nullable()
        table.dateTime("LastUpdate").notNullable()
        table.boolean("IsDropShipper").nullable()
        table.boolean("NotifyOnCancelledOrder").nullable()
        table.string("NotifyOnCancelledOrderEmailSubject").nullable()
        table.text("NotifyOnCancelledOrderEmailMessage").nullable()
        table.integer("POStyle").nullable()
        table.boolean("POEmailNotification").nullable()
        table.text("POShippingInfo").nullable()
        table.text("POPaymentInfo").nullable()
        table.text("POAdditionalNotes").nullable()
        table.string("POEmailSubject").nullable()

        table.bigInteger("_uid").notNullable().unsigned() # native 3DCart id
        table.string("_avatarId").notNullable()
        table.dateTime("_createdAt").notNullable()
        table.dateTime("_updatedAt").notNullable()
        table.unique(["_uid", "_avatarId"], "_3dcartdistributors__uid__avatarid_unique") # index name is optional; it's added here as workaround for a number "3" in the beginning of index name
