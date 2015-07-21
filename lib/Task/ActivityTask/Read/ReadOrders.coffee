_ = require "underscore"
Promise = require "bluebird"
Read = require "../../../../core/lib/Task/ActivityTask/Read"

class ReadOrders extends Read
  constructor: (options, dependencies) ->
    _.defaults options,
      params: {}
    _.defaults options.params,
      limit: 100
    super
  execute: ->
    Promise.bind(@)
    .then @getTotal
    .then @readChapter
    .all()
  readChapter: (total) ->
    offset = 1
    pages = []
    while offset <= total
      pages.push @readPage({offset: offset})
      offset += @params.limit
    pages
  getTotal: ->
    params = {countonly: 1}
    _.defaults params, @params
    @info "ReadOrders:getTotalRequest", @details({params: params})
    @binding.getOrders(params).bind(@)
    .spread (response, body) ->
      @info "ReadOrders:getTotalResponse", @details({params: params, response: response.toJSON(), body: body})
      @progressInit(body.TotalCount)
      .thenReturn(body.TotalCount)
  readPage: (params) ->
    _.defaults params, @params
    @info "ReadOrders:readPageRequest", @details({params: params})
    @binding.getOrders(params).bind(@)
    .spread (response, body) ->
      @info "ReadOrders:readPageResponse", @details({params: params, response: response.toJSON(), body: body})
      @output.write(object) for object in body
      [response, body]

module.exports = ReadOrders