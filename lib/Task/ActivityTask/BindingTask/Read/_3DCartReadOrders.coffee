_ = require "underscore"
Promise = require "bluebird"
_3DCartBinding = require "../../../../_3DCartBinding"
LimitOffset = require "../../../../../core/lib/Task/ActivityTask/BindingTask/Read/LimitOffset"

class _3DCartReadOrders extends LimitOffset
  constructor: (input, options, dependencies) ->
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