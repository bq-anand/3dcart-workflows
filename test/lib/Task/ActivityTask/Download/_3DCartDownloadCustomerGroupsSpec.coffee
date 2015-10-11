_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../core/test-helper/input"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

Binding = require "../../../../../lib/_3DCartBinding"
_3DCartDownloadCustomerGroups = require "../../../../../lib/Task/ActivityTask/Download/_3DCartDownloadCustomerGroups"
create_3DCartCustomerGroups = require "../../../../../lib/Model/_3DCartCustomerGroups"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveCustomerGroups/sample.json"

describe "_3DCartDownloadCustomerGroups", ->
  dependencies = createDependencies(settings, "_3DCartDownloadCustomerGroups")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  _3DCartCustomerGroups = create_3DCartCustomerGroups bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartCustomerGroups.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartDownloadCustomerGroups(
      _.defaults
        _3DCartReadCustomerGroups:
          avatarId: input.avatarId
          params: {}
        _3DCartSaveCustomerGroups:
          avatarId: input.avatarId
          params: {}
      , input
    ,
      activityId: "_3DCartDownloadCustomerGroups"
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
          activityId: "_3DCartDownloadCustomerGroups", isStarted: true, isCompleted: false, isFailed: false
        ]
        isStarted: true, isCompleted: false, isFailed: false
    ]

  it "should run @fast", ->
    @timeout(10000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadCustomerGroups/normal.json", (recordingDone) ->
        task.execute()
        .then ->
          knex(_3DCartCustomerGroups::tableName).count("id")
          .then (results) ->
            results[0].count.should.be.equal("2")
        .then ->
          _3DCartCustomerGroups.where({Name: "Bellefit Test Group"}).fetch()
          .then (model) ->
            should.exist(model)
            model.get("Description").should.be.equal("TEST CUSTOMERS")
        .then ->
          Commands.findOne(task.commandId)
          .then (command) ->
            command.progressBars[0].total.should.be.equal(2)
            command.progressBars[0].current.should.be.equal(2)
        .then resolve
        .catch reject
        .finally recordingDone
