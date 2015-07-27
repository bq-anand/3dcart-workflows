_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createDependencies = require "../../../../../../core/test-helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

_3DCartReadOrders = require "../../../../../../lib/Task/ActivityTask/BindingTask/Read/_3DCartReadOrders"

describe "_3DCartReadOrders", ->
  dependencies = createDependencies(settings)
  mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")

  task = null;

  before ->

  beforeEach ->
    task = new _3DCartReadOrders(
      avatarId: "jTq97yYndzYB5FtpL"
      params:
        datestart: "09/10/2013"
        dateend: "09/15/2013"
    ,
      {}
    ,
      in: new stream.Readable({objectMode: true})
      out: new stream.PassThrough({objectMode: true})
    ,
      dependencies
    )
    Promise.all [
      Credentials.insert
        avatarId: "jTq97yYndzYB5FtpL"
        api: "_3DCart"
        scopes: ["*"]
        details: settings.credentials["_3DCart"]["Generic"]
    ]

  afterEach ->
    Promise.all [
      Credentials.remove()
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
        .then resolve
        .catch reject
        .finally recordingDone
