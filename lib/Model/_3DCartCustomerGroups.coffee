_ = require "underscore"
helper = require "../../core/helper/model"

module.exports = (bookshelf) ->
  bookshelf.Model.extend
    tableName: "_3DCartCustomerGroups"
    hasTimestamps: ['_createdAt', '_updatedAt']
  ,
    _.extend helper(bookshelf),
      buildTable: (table) ->
        table.increments()
        table.string("Name").notNullable()
        table.text("Description").nullable()
        table.decimal("MinimumOrder", 10, 2).defaultTo(0)
        table.boolean("NonTaxable").nullable()
        table.boolean("AllowRegistration").nullable()
        table.boolean("DisableRewardPoints").nullable()
        table.boolean("AutoApprove").nullable()
        table.text("RegistrationMessage").nullable()
        table.integer("PriceLevel").nullable()

        table.bigInteger("_uid").notNullable().unsigned() # native 3DCart id
        table.string("_avatarId").notNullable()
        table.dateTime("_createdAt").notNullable()
        table.dateTime("_updatedAt").notNullable()
        table.unique(["_uid", "_avatarId"], "_3dcartcustomergroups__uid__avatarid_unique") # index name is optional; it's added here as workaround for a number "3" in the beginning of index name
