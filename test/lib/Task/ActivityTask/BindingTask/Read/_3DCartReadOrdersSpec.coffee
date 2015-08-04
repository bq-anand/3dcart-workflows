_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../../core/test-helper/input"
createDependencies = require "../../../../../../core/helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

_3DCartReadOrders = require "../../../../../../lib/Task/ActivityTask/BindingTask/Read/_3DCartReadOrders"

describe "_3DCartReadOrders", ->
  dependencies = createDependencies(settings, "_3DCartReadOrders")
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  task = null;

  before ->

  beforeEach ->
    task = new _3DCartReadOrders(
      _.defaults
        params:
          datestart: "09/10/2013"
          dateend: "09/15/2013"
      , input
    ,
      activityId: "_3DCartReadOrders"
    ,
      in: new stream.Readable({objectMode: true})
      out: new stream.PassThrough({objectMode: true})
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
      console.log new Date()
    .then ->
      Promise.all [
        Credentials.insert
          avatarId: input.avatarId
          api: "_3DCart"
          scopes: ["*"]
          details: settings.credentials["_3DCart"]["Generic"]
        Commands.insert
          _id: input.commandId
          progressBars: [
            activityId: "_3DCartReadOrders", isStarted: true, isFinished: false
          ]
      ]

  it "should run", ->
    @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadOrders/normal.json", (recordingDone) ->
        sinon.spy(task.out, "write")
        sinon.spy(task.binding, "request")
        task.execute()
        .then ->
          task.binding.request.should.have.callCount(5)
          task.out.write.should.have.callCount(306)
          task.out.write.should.always.have.been.calledWithMatch sinon.match (object) ->
            if not object.hasOwnProperty("OrderID")
              console.log object
            object.hasOwnProperty("OrderID")
          , "Object has own property \"OrderID\""
        .then ->
          Commands.findOne(input.commandId)
          .then (command) ->
            command.progressBars[0].total.should.be.equal(306)
            command.progressBars[0].current.should.be.equal(306)
        .then resolve
        .catch reject
        .finally recordingDone
