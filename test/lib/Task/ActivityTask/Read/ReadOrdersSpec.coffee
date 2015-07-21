_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createLogger = require "../../../../../core/helper/logger"
createKnex = require "../../../../../core/helper/knex"
createBookshelf = require "../../../../../core/helper/bookshelf"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

Binding = require "../../../../../lib/Binding"
ReadOrders = require "../../../../../lib/Task/ActivityTask/Read/ReadOrders"

describe "ReadOrders", ->
  binding = null; logger = null; job = null;

  before ->
    binding = new Binding
      credential: settings.credentials.bellefit
    logger = createLogger settings.logger

  beforeEach ->
    job = new ReadOrders(
      params:
        datestart: "09/10/2013"
        dateend: "09/15/2013"
    ,
      input: new stream.Readable({objectMode: true})
      output: new stream.PassThrough({objectMode: true})
      binding: binding
      logger: logger
    )

  it "should run", ->
    @timeout(20000) if process.env.NOCK_BACK_MODE is "record"
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/ReadOrders/run.json", (recordingDone) ->
        sinon.spy(job.output, "write")
        sinon.spy(job.binding, "request")
        job.execute()
        .then ->
          job.binding.request.should.have.callCount(5)
          job.output.write.should.have.callCount(306)
          job.output.write.should.always.have.been.calledWithMatch sinon.match (object) ->
            if not object.hasOwnProperty("OrderID")
              console.log object
            object.hasOwnProperty("OrderID")
          , "Object has own property \"OrderID\""
        .then resolve
        .catch reject
        .finally recordingDone