_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

_3DCartSaveOrders = require "../../../../../lib/Task/ActivityTask/Save/_3DCartSaveOrders"
create_3DCartOrders = require "../../../../../lib/Model/_3DCartOrders"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveOrders/sample.json"

describe "_3DCartSaveOrders", ->
  dependencies = createDependencies(settings)
  knex = dependencies.knex; bookshelf = dependencies.bookshelf

  _3DCartOrders = create_3DCartOrders bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartOrders.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartSaveOrders(
      avatarId: "wuXMSggRPPmW4FiE9"
    ,
      {}
    ,
      in: new stream.PassThrough({objectMode: true})
      out: new stream.PassThrough({objectMode: true})
    ,
      dependencies
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
