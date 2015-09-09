_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
_3DCartBinding = require "../../../_3DCartBinding"
Write = require "../../../../core/lib/Strategy/APIStrategy/Write"

class _3DCartWriteOrderInternalComment extends Write
  createBinding: -> new _3DCartBinding({scopes: ["*"]})

  execute: ->
    Promise.bind(@)
    .then @acquireCredential
    .then ->
      @binding.getOrders(@params)
      .bind(@)
      .spread (response, body) ->
        body
    .then (orders) ->
      objects = []
      for order in orders
        objects.push
          OrderID: order.OrderID
          InternalComments: "#{@commenter} - #{@commentedAt}\r\nComment: #{@text}\r\n\r\n#{order.InternalComments}"
      @binding.updateOrders(objects)
    .then -> {}

module.exports = _3DCartWriteOrderInternalComment
