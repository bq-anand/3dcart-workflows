_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../../core/test-helper/input"
createDependencies = require "../../../../../../core/helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

_3DCartReadOrders = require "../../../../../../lib/Strategy/APIStrategy/Read/LimitOffset/_3DCartReadOrders"

describe "_3DCartReadOrders", ->
  dependencies = createDependencies(settings, "_3DCartReadOrders")
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  strategy = null;

  before ->

  beforeEach ->
    strategy = new _3DCartReadOrders(
      _.defaults
        params:
          datestart: "09/10/2013"
          dateend: "09/15/2013"
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

  it "should run @fast", ->
    console.log process.env.NOCK_BACK_MODE
    @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadOrders/normal.json", (recordingDone) ->
        onBindingRequest = sinon.spy(strategy.binding, "request")
        onObjectSpy = sinon.spy()
        strategy.on "object", onObjectSpy
        strategy.execute()
        .then ->
          onBindingRequest.should.have.callCount(5)
          onObjectSpy.should.have.callCount(306)
          onObjectSpy.should.always.have.been.calledWithMatch sinon.match (object) ->
            if not object.hasOwnProperty("OrderID")
              console.log object
            object.hasOwnProperty("OrderID")
          , "Object has own property \"OrderID\""
        .then resolve
        .catch reject
        .finally recordingDone
