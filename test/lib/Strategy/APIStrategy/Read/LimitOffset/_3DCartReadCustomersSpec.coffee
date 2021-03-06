_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../../core/test-helper/input"
createDependencies = require "../../../../../../core/helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

_3DCartReadCustomers = require "../../../../../../lib/Strategy/APIStrategy/Read/LimitOffset/_3DCartReadCustomers"

describe "_3DCartReadCustomers", ->
  dependencies = createDependencies(settings, "_3DCartReadCustomers")
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  strategy = null;

  before ->

  beforeEach ->
    strategy = new _3DCartReadCustomers(
      _.defaults {}, input
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
    if process.env.NOCK_BACK_MODE is "record"
      @timeout(20000)
    else
      @timeout(10000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadCustomers/normal.json", (recordingDone) ->
        onBindingRequest = sinon.spy(strategy.binding, "request")
        onObjectSpy = sinon.spy()
        strategy.on "object", onObjectSpy
        strategy.execute()
        .then ->
          onBindingRequest.should.have.callCount(76)
          onObjectSpy.should.have.callCount(7426)
          onObjectSpy.should.always.have.been.calledWithMatch sinon.match (object) ->
            if not object.hasOwnProperty("CustomerID")
              console.log object
            object.hasOwnProperty("CustomerID")
          , "Object has own property \"CustomerID\""
        .then resolve
        .catch reject
        .finally recordingDone
