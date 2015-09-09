_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
_3DCartBinding = require "../../_3DCartBinding"
ActivityTask = require "../../../core/lib/Task/ActivityTask"

class _3DCartWriteOrderInternalComment extends ActivityTask
  execute: ->
    Promise.bind(@)
    .then @acquireCredential
    .then ->
      @binding.getOrders(@params)
      .bind(@)
      .spread (response, body) ->
        body
    .then (orders) -> @progressBarSetTotal(orders.length).thenReturn(orders)
    .then (orders) ->
      objects = []
      for order in orders
        objects.push
          OrderID: order.OrderID
          InternalComments: "#{@commenter} - #{@commentedAt}\r\nComment: #{@text}\r\n\r\n#{order.InternalComments}"
      @binding.updateOrders(objects).thenReturn(orders)
    .then (orders) -> @progressBarIncCurrent(orders.length)
    .then -> {}


  ###
  # Need to refactor all this code out into a strategy
  ###

  constructor: (input, dependencies) ->
    Match.check input, Match.ObjectIncluding
      avatarId: String
    @binding = @createBinding()
    @mongodb = dependencies.mongodb
    Match.check @mongodb, Match.Any
    super

  acquireCredential: ->
    selector =
      avatarId: @avatarId
      api: @binding.api
      scopes: {$all: @binding.scopes}
    Promise.bind(@)
    .then -> @mongodb.collection("Credentials").findOne(selector)
    .then (credential) ->
      throw new errors.RuntimeError(
        message: "Can't find API credential"
        selector: selector
      ) unless credential
      @binding.setCredential(credential)
      @binding

  createBinding: -> new _3DCartBinding({scopes: ["*"]})

module.exports = _3DCartWriteOrderInternalComment
