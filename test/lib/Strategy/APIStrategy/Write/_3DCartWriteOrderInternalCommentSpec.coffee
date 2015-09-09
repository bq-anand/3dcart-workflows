_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../core/test-helper/input"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

_3DCartWriteOrderInternalComment = require "../../../../../lib/Strategy/APIStrategy/Write/_3DCartWriteOrderInternalComment"

describe "_3DCartWriteOrderInternalComment", ->
  dependencies = createDependencies(settings, "_3DCartWriteOrderInternalComment")
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  strategy = null
  orderId = "47620"
  initialComments = "Dennis - 7/20/2015 12:05:34 PM\r\nComment: Initial internal comment\r\n\r\n"

  before ->

  beforeEach ->
    strategy = new _3DCartWriteOrderInternalComment(
      _.defaults
        params:
          OrderId: orderId
        text: "New internal comment"
        commenter: "Dennis"
        commentedAt: "17/20/2015 13:45:34 PM"
      , input
    ,
      dependencies
    )
    Promise.bind(@)
    .then ->
      Promise.all [
        Credentials.remove()
        Commands.remove()
        Issues.remove()
      ]
    .then ->
      Promise.all [
        Credentials.insert
          avatarId: input.avatarId
          api: "_3DCart"
          scopes: ["*"]
          details: settings.credentials["_3DCart"]["Generic"]
      ]
    .then ->
      @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
      new Promise (resolve, reject) ->
        nock.back "test/fixtures/_3DCartWriteOrderInternalComment/init.json", (recordingDone) ->
          strategy
          .acquireCredential()
          .then ->
            @binding.updateOrders([{OrderID: orderId, InternalComments: initialComments}])
          .then resolve
          .catch reject
          .finally recordingDone


  it "should run @fast", ->
    @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartWriteOrderInternalComment/normal.json", (recordingDone) ->
        onBindingRequest = sinon.spy(strategy.binding, "request")
        strategy.execute()
        .then ->
          onBindingRequest.should.have.callCount(2)
          strategy.binding.getOrders(strategy.params)
          .spread (response, body) ->
            order = body[0]
            order.InternalComments.should.be.equal("#{strategy.commenter} - #{strategy.commentedAt}\r\nComment: #{strategy.text}\r\n\r\n#{initialComments}")
        .then resolve
        .catch reject
        .finally recordingDone
