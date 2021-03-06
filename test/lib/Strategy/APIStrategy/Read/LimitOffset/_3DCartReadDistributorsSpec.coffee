_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../../core/test-helper/input"
createDependencies = require "../../../../../../core/helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

_3DCartReadDistributors = require "../../../../../../lib/Strategy/APIStrategy/Read/LimitOffset/_3DCartReadDistributors"

describe "_3DCartReadDistributors", ->
  dependencies = createDependencies(settings, "_3DCartReadDistributors")
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  strategy = null;

  before ->

  beforeEach ->
    strategy = new _3DCartReadDistributors(
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
    @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadDistributors/normal.json", (recordingDone) ->
        onBindingRequest = sinon.spy(strategy.binding, "request")
        onObjectSpy = sinon.spy()
        strategy.on "object", onObjectSpy
        strategy.execute()
        .then ->
          onBindingRequest.should.have.callCount(1)
          onObjectSpy.should.have.callCount(0)
#          onObjectSpy.should.always.have.been.calledWithMatch sinon.match (object) ->
#            if not object.hasOwnProperty("DistributorID")
#              console.log object
#            object.hasOwnProperty("DistributorID")
#          , "Object has own property \"DistributorID\""
        .then resolve
        .catch reject
        .finally recordingDone
