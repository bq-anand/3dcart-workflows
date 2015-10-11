_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../core/test-helper/input"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

Binding = require "../../../../../lib/_3DCartBinding"
_3DCartDownloadCustomers = require "../../../../../lib/Task/ActivityTask/Download/_3DCartDownloadCustomers"
create_3DCartCustomers = require "../../../../../lib/Model/_3DCartCustomers"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveCustomers/sample.json"

describe "_3DCartDownloadCustomers", ->
  dependencies = createDependencies(settings, "_3DCartDownloadCustomers")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  _3DCartCustomers = create_3DCartCustomers bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartCustomers.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartDownloadCustomers(
      _.defaults
        _3DCartReadCustomers:
          avatarId: input.avatarId
          params: {}
        _3DCartSaveCustomers:
          avatarId: input.avatarId
          params: {}
      , input
    ,
      activityId: "_3DCartDownloadCustomers"
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
          activityId: "_3DCartDownloadCustomers", isStarted: true, isCompleted: false, isFailed: false
        ]
        isStarted: true, isCompleted: false, isFailed: false
    ]

  it "should run @fast", ->
    @timeout(20000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadCustomers/normal.json", (recordingDone) ->
        task.execute()
        .then ->
          knex(_3DCartCustomers::tableName).count("id")
          .then (results) ->
            results[0].count.should.be.equal("7426")
        .then ->
          _3DCartCustomers.where({Email: "tbitner@gmail.com"}).fetch()
          .then (model) ->
            should.exist(model)
            model.get("BillingLastName").should.be.equal("Bitner-McGraw")
        .then ->
          Commands.findOne(task.commandId)
          .then (command) ->
            command.progressBars[0].total.should.be.equal(7426)
            command.progressBars[0].current.should.be.equal(7426)
        .then resolve
        .catch reject
        .finally recordingDone
