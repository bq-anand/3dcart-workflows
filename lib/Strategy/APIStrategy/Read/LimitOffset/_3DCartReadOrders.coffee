_ = require "underscore"
Promise = require "bluebird"
LimitOffset = require "../../../../../core/lib/Strategy/APIStrategy/Read/LimitOffset"
_3DCartBinding = require "../../../../_3DCartBinding"

class _3DCartReadOrders extends LimitOffset
  constructor: (input, dependencies) ->
    _.defaults input,
      offset: 1
    super

  createBinding: -> new _3DCartBinding({scopes: ["*"]})
  getTotalParams: -> _.extend {countonly: 1}, @params
  getTotalRequest: (params) -> @binding.getOrders(params)
  extractTotalFromResponse: (response, body) -> body.TotalCount
  getPageParams: (limit, offset) -> _.extend {limit: limit, offset: offset}, @params
  getPageRequest: (params) -> @binding.getOrders(params)

module.exports = _3DCartReadOrders
