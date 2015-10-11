_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../core/test-helper/input"
createDependencies = require "../../../../../core/helper/dependencies"
settings = (require "../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

Binding = require "../../../../../lib/_3DCartBinding"
_3DCartDownloadProducts = require "../../../../../lib/Task/ActivityTask/Download/_3DCartDownloadProducts"
create_3DCartProducts = require "../../../../../lib/Model/_3DCartProducts"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveProducts/sample.json"

describe "_3DCartDownloadProducts", ->
  dependencies = createDependencies(settings, "_3DCartDownloadProducts")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  _3DCartProducts = create_3DCartProducts bookshelf

  task = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartProducts.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    task = new _3DCartDownloadProducts(
      _.defaults
        _3DCartReadProducts:
          avatarId: input.avatarId
          params: {}
        _3DCartSaveProducts:
          avatarId: input.avatarId
          params: {}
      , input
    ,
      activityId: "_3DCartDownloadProducts"
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
          activityId: "_3DCartDownloadProducts", isStarted: true, isCompleted: false, isFailed: false
        ]
        isStarted: true, isCompleted: false, isFailed: false
    ]

  it "should run @fast", ->
    @timeout(20000)
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/_3DCartReadProducts/normal.json", (recordingDone) ->
        task.execute()
        .then ->
          knex(_3DCartProducts::tableName).count("id")
          .then (results) ->
            results[0].count.should.be.equal("35")
        .then ->
          _3DCartProducts.where({ShortDescription: "Bellefit Girdle with front hooks (Corset)"}).fetch()
          .then (model) ->
            should.exist(model)
            model.get("ProductLink").should.be.equal("http://bellefitdevelopment.3dcartstores.com/corset.php")
        .then ->
          Commands.findOne(task.commandId)
          .then (command) ->
            command.progressBars[0].total.should.be.equal(35)
            command.progressBars[0].current.should.be.equal(35)
        .then resolve
        .catch reject
        .finally recordingDone
