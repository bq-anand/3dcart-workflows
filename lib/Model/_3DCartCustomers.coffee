_ = require "underscore"
helper = require "../../core/helper/model"

module.exports = (bookshelf) ->
  bookshelf.Model.extend
    tableName: "_3DCartCustomers"
    hasTimestamps: ['_createdAt', '_updatedAt']
  ,
    _.extend helper(bookshelf),
      buildTable: (table) ->
        table.increments()
        table.string("Email").notNullable()
        table.string("Password").notNullable()
        table.string("BillingCompany").nullable()
        table.string("BillingFirstName").nullable()
        table.string("BillingLastName").nullable()
        table.string("BillingAddress1").nullable()
        table.string("BillingAddress2").nullable()
        table.string("BillingCity").nullable()
        table.string("BillingState").nullable()
        table.string("BillingZipCode").nullable()
        table.string("BillingCountry").nullable()
        table.string("BillingPhoneNumber").nullable()
        table.integer("BillingTaxID").nullable()
        table.string("ShippingCompany").nullable()
        table.string("ShippingFirstName").nullable()
        table.string("ShippingLastName").nullable()
        table.string("ShippingAddress1").nullable()
        table.string("ShippingAddress2").nullable()
        table.string("ShippingCity").nullable()
        table.string("ShippingState").nullable()
        table.string("ShippingZipCode").nullable()
        table.string("ShippingCountry").nullable()
        table.string("ShippingPhoneNumber").nullable()
        table.integer("ShippingAddressType").nullable()
        table.integer("CustomerGroupID").nullable()
        table.boolean("Enabled").nullable()
        table.boolean("MailList").nullable()
        table.boolean("NonTaxable").nullable()
        table.boolean("DisableBillingSameAsShipping").nullable()
        table.string("Comments").nullable()
        table.string("AdditionalField1").nullable()
        table.string("AdditionalField2").nullable()
        table.string("AdditionalField3").nullable()

        table.bigInteger("_uid").notNullable().unsigned() # native 3DCart id
        table.string("_avatarId").notNullable()
        table.dateTime("_createdAt").notNullable()
        table.dateTime("_updatedAt").notNullable()
        table.unique(["_uid", "_avatarId"], "_3dcartcustomers__uid__avatarid_unique") # index name is optional; it's added here as workaround for a number "3" in the beginning of index name
