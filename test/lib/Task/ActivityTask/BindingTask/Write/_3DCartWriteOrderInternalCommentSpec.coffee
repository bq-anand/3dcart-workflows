_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../../core/test-helper/input"
createDependencies = require "../../../../../../core/helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

_3DCartWriteOrderInternalComment = require "../../../../../../lib/Task/ActivityTask/BindingTask/Write/_3DCartWriteOrderInternalComment"

describe "_3DCartWriteOrderInternalComment", ->
  dependencies = createDependencies(settings, "_3DCartWriteOrderInternalComment")
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  task = null;

  before ->

  beforeEach ->
    task = new _3DCartWriteOrderInternalComment(
      _.defaults
        params:
          orderid: 47620
        text: "New internal comment"
      , input
    ,
      activityId: "_3DCartWriteOrderInternalComment"
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
    .then ->
      @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
      new Promise (resolve, reject) ->
        nock.back "test/fixtures/_3DCartWriteOrderInternalComment/init.json", (recordingDone) ->
          task
          .acquireCredential()
          .then ->
            @binding.updateOrders([{OrderID: @params.orderid, InternalComments: "Initial internal comment"}])
          .then resolve
          .catch reject
          .finally recordingDone


  it "should run", ->
    @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartWriteOrderInternalComment/normal.json", (recordingDone) ->
        sinon.spy(task.out, "write")
        sinon.spy(task.binding, "request")
        task.execute()
        .then ->
          task.binding.request.should.have.callCount(2)
          task.out.write.should.have.callCount(1)
          task.out.write.should.always.have.been.calledWithMatch sinon.match (object) ->
            check = object.Key is "OrderID" and object.Value is "47620" and object.Status is "200"
            if not check
              console.log object
            check
          , "Order update is not successful"
        .then resolve
        .catch reject
        .finally recordingDone
