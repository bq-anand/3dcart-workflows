_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../core/test-helper/input"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

Binding = require "../../../../../lib/_3DCartBinding"
_3DCartDownloadManufacturers = require "../../../../../lib/Task/ActivityTask/Download/_3DCartDownloadManufacturers"
create_3DCartManufacturers = require "../../../../../lib/Model/_3DCartManufacturers"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveManufacturers/sample.json"

describe "_3DCartDownloadManufacturers", ->
  dependencies = createDependencies(settings, "_3DCartDownloadManufacturers")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  _3DCartManufacturers = create_3DCartManufacturers bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartManufacturers.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartDownloadManufacturers(
      _.defaults
        _3DCartReadManufacturers:
          avatarId: input.avatarId
          params: {}
        _3DCartSaveManufacturers:
          avatarId: input.avatarId
          params: {}
      , input
    ,
      activityId: "_3DCartDownloadManufacturers"
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
          activityId: "_3DCartDownloadManufacturers", isStarted: true, isCompleted: false, isFailed: false
        ]
        isStarted: true, isCompleted: false, isFailed: false
    ]

  it "should run @fast", ->
    @timeout(20000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadManufacturers/normal.json", (recordingDone) ->
        task.execute()
        .then ->
          knex(_3DCartManufacturers::tableName).count("id")
          .then (results) ->
            results[0].count.should.be.equal("1")
        .then ->
          _3DCartManufacturers.where({ManufacturerName: "BELLEFIT, INC"}).fetch()
          .then (model) ->
            should.exist(model)
            model.get("Website").should.be.equal("www.bellefit.com")
        .then ->
          Commands.findOne(task.commandId)
          .then (command) ->
            command.progressBars[0].total.should.be.equal(1)
            command.progressBars[0].current.should.be.equal(1)
        .then resolve
        .catch reject
        .finally recordingDone
