_ = require "underscore"
Promise = require "bluebird"
LimitOffset = require "../../../../core/lib/Task/ActivityTask/Read/LimitOffset"

class _3DCartReadOrders extends LimitOffset
  constructor: (input, options, dependencies) ->
    _.defaults input,
      offset: 1
    super

  getTotalParams: -> _.extend {countonly: 1}, @params
  getTotalRequest: (params) -> @binding.getOrders(params)
  extractTotalFromResponse: (response, body) -> body.TotalCount
  getPageParams: (limit, offset) -> _.extend {limit: limit, offset: offset}, @params
  getPageRequest: (params) -> @binding.getOrders(params)

module.exports = _3DCartReadOrders