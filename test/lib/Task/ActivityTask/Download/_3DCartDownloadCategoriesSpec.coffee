_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../core/test-helper/input"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

Binding = require "../../../../../lib/_3DCartBinding"
_3DCartDownloadCategories = require "../../../../../lib/Task/ActivityTask/Download/_3DCartDownloadCategories"
create_3DCartCategories = require "../../../../../lib/Model/_3DCartCategories"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveCategories/sample.json"

describe "_3DCartDownloadCategories", ->
  dependencies = createDependencies(settings, "_3DCartDownloadCategories")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  _3DCartCategories = create_3DCartCategories bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartCategories.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartDownloadCategories(
      _.defaults
        _3DCartReadCategories:
          avatarId: input.avatarId
          params: {}
        _3DCartSaveCategories:
          avatarId: input.avatarId
          params: {}
      , input
    ,
      activityId: "_3DCartDownloadCategories"
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
          activityId: "_3DCartDownloadCategories", isStarted: true, isCompleted: false, isFailed: false
        ]
        isStarted: true, isCompleted: false, isFailed: false
    ]

  it "should run @fast", ->
    @timeout(10000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadCategories/normal.json", (recordingDone) ->
        task.execute()
        .then ->
          knex(_3DCartCategories::tableName).count("id")
          .then (results) ->
            results[0].count.should.be.equal("38")
        .then ->
          _3DCartCategories.where({CategoryName: "Bellefit Girdles"}).fetch()
          .then (model) ->
            should.exist(model)
            model.get("Link").should.be.equal("http://www.bellefit.com/recovery.php")
        .then ->
          Commands.findOne(task.commandId)
          .then (command) ->
            command.progressBars[0].total.should.be.equal(38)
            command.progressBars[0].current.should.be.equal(38)
        .then resolve
        .catch reject
        .finally recordingDone
