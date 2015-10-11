_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createDependencies = require "../../core/helper/dependencies"
settings = (require "../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

_3DCartOrdersSerializer = require "../../lib/Serializer/_3DCartOrdersSerializer"
create_3DCartOrders = require "../../lib/Model/_3DCartOrders"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveOrders/sample.json"

describe "_3DCartOrdersSerializer", ->
  dependencies = createDependencies(settings, "_3DCartOrdersSerializer")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf

  _3DCartOrder = create_3DCartOrders bookshelf

  serializer = null

  after ->
    knex.destroy()

  beforeEach ->
    serializer = new _3DCartOrdersSerializer
      model: _3DCartOrder

  it "should be idempotent @fast", ->
    sampleMirror = serializer.toExternal(serializer.toInternal(sample))
    sample.should.be.deep.equal(sampleMirror)

  it "should remap OrderID to _uid @fast", ->
    serializer.toInternal(sample)._uid.should.be.equal(sample.OrderID)

  it "should transform created_at::string into created_at::Date @fast", ->
    serializer.toInternal(sample).OrderDate.should.be.an.instanceof(Date)
