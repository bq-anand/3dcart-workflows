_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createLogger = require "../../core/helper/logger"
createKnex = require "../../core/helper/knex"
createBookshelf = require "../../core/helper/bookshelf"
settings = (require "../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

_3DCartSerializer = require "../../lib/_3DCartSerializer"
create_3DCartOrders = require "../../lib/Model/_3DCartOrders"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveOrders/sample.json"

describe "Serializer", ->
  serializer = null; knex = null; _3DCartOrder = null;

  before (beforeDone) ->
    knex = createKnex settings.knex
    bookshelf = createBookshelf knex
    _3DCartOrder = create_3DCartOrders bookshelf
    beforeDone()

  after (teardownDone) ->
    knex.destroy()
    .nodeify teardownDone

  beforeEach ->
    serializer = new _3DCartSerializer
      model: _3DCartOrder

  it "should be idempotent", ->
    sampleMirror = serializer.toExternal(serializer.toInternal(sample))
    sample.should.be.deep.equal(sampleMirror)

  it "should remap OrderID to _uid", ->
    serializer.toInternal(sample)._uid.should.be.equal(sample.OrderID)

  it "should transform created_at::string into created_at::Date", ->
    serializer.toInternal(sample).OrderDate.should.be.an.instanceof(Date)