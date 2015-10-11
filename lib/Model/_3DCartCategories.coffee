_ = require "underscore"
helper = require "../../core/helper/model"

module.exports = (bookshelf) ->
  bookshelf.Model.extend
    tableName: "_3DCartCategories"
    hasTimestamps: ['_createdAt', '_updatedAt']
  ,
    _.extend helper(bookshelf),
      buildTable: (table) ->
        table.increments()
        table.string("CategoryName").nullable()
        table.string("Link").nullable()
        table.text("CategoryDescription").nullable()
        table.string("CategoryIcon").nullable()
        table.boolean("CategoryMain").nullable()
        table.integer("CategoryParent").nullable()
        table.integer("Sorting").nullable()
        table.boolean("Hide").nullable()
        table.string("UserID").nullable()
        table.dateTime("LastUpdate").notNullable()
        table.integer("CategoryMenuGroup").nullable()
        table.boolean("HomeSpecialCategory").nullable()
        table.boolean("FilterCategory").nullable()
        table.integer("TemplateCategoryPage").nullable()
        table.integer("DefaultProductsSorting").nullable()
        table.integer("SubcategoryColumnsCategorySpecials").nullable()
        table.integer("ProductColumnsCategorySpecials").nullable()
        table.integer("ProductColumnsCategoryGeneralItems").nullable()
        table.integer("ItemsPerPageCategorySpecialItems").nullable()
        table.integer("ItemsPerPageCategoryGeneralItems").nullable()
        table.integer("DisplayTypeCategorySpecialItems").nullable()
        table.integer("DisplayTypeCategoryGeneralProducts").nullable()
        table.string("AllowAccess").nullable()
        table.string("OnFailRedirectTo").nullable()
        table.boolean("HideLeftBar").nullable()
        table.boolean("HideRightBar").nullable()
        table.boolean("HideTopMenu").nullable()
        table.integer("SmartCategories").nullable()
        table.string("SmartCategoriesSearchKeyword").nullable()
        table.string("SmartCategoriesLinkTarget").nullable()
        table.integer("TemplateProductPage").nullable()
        table.integer("ProductColumnsRelatedProducts").nullable()
        table.integer("ProductColumnsUpsellProducts").nullable()
        table.integer("DisplayTypeRelatedItems").nullable()
        table.integer("DisplayTypeUpsellItems").nullable()
        table.specificType("OptionSetList", "jsonb[]").nullable()
        table.string("Title").nullable()
        table.string("CustomFileName").nullable()
        table.string("MetaTags").nullable()
        table.string("CategoryHeader").nullable()
        table.string("CategoryFooter").nullable()
        table.string("AdditionalKeywords").nullable()

        table.bigInteger("_uid").notNullable().unsigned() # native 3DCart id
        table.string("_avatarId").notNullable()
        table.dateTime("_createdAt").notNullable()
        table.dateTime("_updatedAt").notNullable()
        table.unique(["_uid", "_avatarId"], "_3dcartcategories__uid__avatarid_unique") # index name is optional; it's added here as workaround for a number "3" in the beginning of index name
