_ = require "underscore"
_.mixin require "underscore.deep"
Serializer = require "../../core/lib/Serializer"

class _3DCartCustomerGroupsSerializer extends Serializer
  constructor: (options) ->
    super

  keymap: ->
    "CustomerGroupID": "_uid"

  dateFormat: -> "YYYY-MM-DDTHH:mm:ss"

module.exports = _3DCartCustomerGroupsSerializer
