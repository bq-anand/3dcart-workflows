_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createLogger = require "../../../../../core/helper/logger"
createKnex = require "../../../../../core/helper/knex"
createBookshelf = require "../../../../../core/helper/bookshelf"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

_3DCartSaveOrders = require "../../../../../lib/Task/ActivityTask/Save/_3DCartSaveOrders"
create_3DCartOrders = require "../../../../../lib/Model/_3DCartOrders"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveOrders/sample.json"

describe "_3DCartSaveOrders", ->
  knex = null; bookshelf = null; logger = null; _3DCartOrders = null; task = null; # shared between tests

  before (beforeDone) ->
    knex = createKnex settings.knex
    knex.Promise.longStackTraces()
    bookshelf = createBookshelf knex
    logger = createLogger settings.logger
    _3DCartOrders = create_3DCartOrders bookshelf
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartOrders.createTable()
    .nodeify beforeDone

  after (teardownDone) ->
    knex.destroy()
    .nodeify teardownDone

  beforeEach ->
    task = new _3DCartSaveOrders(
      avatarId: "wuXMSggRPPmW4FiE9"
    ,
      {}
    ,
      in: new stream.PassThrough({objectMode: true})
      out: new stream.PassThrough({objectMode: true})
      bookshelf: bookshelf
      logger: logger
    )

  it "should run", ->
    task.in.write(sample)
    task.in.end()
    task.execute()
    .then ->
      knex(_3DCartOrders::tableName).count("id")
      .then (results) ->
        results[0].count.should.be.equal("1")
    .then ->
      _3DCartOrders.where({id: 1}).fetch()
      .then (model) ->
        model.get("InvoiceNumber").should.be.equal(24545)
