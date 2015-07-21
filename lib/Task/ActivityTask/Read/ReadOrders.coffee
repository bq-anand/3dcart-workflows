_ = require "underscore"
Promise = require "bluebird"
LimitOffset = require "../../../../core/lib/Task/ActivityTask/Read/LimitOffset"

class ReadOrders extends LimitOffset
  constructor: (options, dependencies) ->
    _.defaults options,
      offset: 1
    super

  getTotalParams: -> _.extend {countonly: 1}, @params
  getTotalRequest: (params) -> @binding.getOrders(params)
  extractTotalFromResponse: (response, body) -> body.TotalCount
  getPageParams: (limit, offset) -> _.extend {limit: limit, offset: offset}, @params
  getPageRequest: (params) -> @binding.getOrders(params)

module.exports = ReadOrders