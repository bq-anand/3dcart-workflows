_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
createDependencies = require "../../../../../core/test-helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

Binding = require "../../../../../lib/_3DCartBinding"
_3DCartDownloadOrders = require "../../../../../lib/Task/ActivityTask/Download/_3DCartDownloadOrders"
create_3DCartOrders = require "../../../../../lib/Model/_3DCartOrders"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveOrders/sample.json"

describe "_3DCartDownloadOrders", ->
  dependencies = createDependencies(settings)
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb

  Credentials = mongodb.collection("Credentials")

  _3DCartOrders = create_3DCartOrders bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartOrders.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartDownloadOrders(
      _3DCartReadOrders:
        input:
          avatarId: "wuXMSggRPPmW4FiE9"
          params:
            datestart: "09/10/2013"
            dateend: "09/15/2013"
      _3DCartSaveOrders:
        input:
          avatarId: "wuXMSggRPPmW4FiE9"
          params: {}
    ,
      {}
    ,
      in: new stream.PassThrough({objectMode: true})
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
    @timeout(10000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadOrders/normal.json", (recordingDone) ->
        task.execute()
        .then ->
          knex(_3DCartOrders::tableName).count("id")
          .then (results) ->
            results[0].count.should.be.equal("306")
        .then ->
          _3DCartOrders.where({InvoiceNumber: 24545}).fetch()
          .then (model) ->
            should.exist(model)
            model.get("BillingFirstName").should.be.equal("Alondra")
        .then resolve
        .catch reject
        .finally recordingDone
