_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
_3DCartBinding = require "../../../../_3DCartBinding"
Write = require "../../../../../core/lib/Task/ActivityTask/BindingTask/Write"

class _3DCartWriteOrderInternalComment extends Write
  constructor: (input, options, streams, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartWriteOrderInternalComment: Object
    @writeArguments = @arguments input, "_3DCartWriteOrderInternalComment"
    super

  createBinding: -> new _3DCartBinding({scopes: ["*"]})

  execute: ->
    Promise.bind(@)
    .then @acquireCredential
    .then ->
      @binding.getOrders(@writeArguments.input.params)
      .bind(@)
      .spread (response, body) ->
        body
    .then (orders) ->
      objects = []
      for order in orders
        objects.push
          OrderID: order.OrderID
          InternalComments: order.InternalComments + "\n----------------------------------\n#{@writeArguments.input.text}"
      @binding.updateOrders(objects).bind(@)
      .spread (response, body) ->
        @out.write(object) for object in body
    .then -> @out.end()
    .then -> {}

module.exports = _3DCartWriteOrderInternalComment
