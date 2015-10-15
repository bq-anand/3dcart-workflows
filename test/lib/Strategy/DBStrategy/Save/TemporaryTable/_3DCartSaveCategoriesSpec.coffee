_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../../../core/test-helper/input"
createDependencies = require "../../../../../../core/helper/dependencies"
settings = (require "../../../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/test.json")

_3DCartSaveCategories = require "../../../../../../lib/Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveCategories"
create_3DCartCategories = require "../../../../../../lib/Model/_3DCartCategories"
sample = require "#{process.env.ROOT_DIR}/test/fixtures/_3DCartSaveCategories/sample.json"

describe "_3DCartSaveCategories", ->
  dependencies = createDependencies(settings, "_3DCartSaveCategories")
  knex = dependencies.knex; bookshelf = dependencies.bookshelf; mongodb = dependencies.mongodb;

  Credentials = mongodb.collection("Credentials")
  Commands = mongodb.collection("Commands")
  Issues = mongodb.collection("Issues")

  _3DCartCategories = create_3DCartCategories bookshelf

  strategy = null # shared between tests

  before ->
    Promise.bind(@)
    .then -> knex.raw("SET search_path TO pg_temp")
    .then -> _3DCartCategories.createTable()

  after ->
    knex.destroy()

  beforeEach ->
    strategy = new _3DCartSaveCategories(
      _.defaults {}, input
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
      ]

  it "should save new objects @fast", ->
    knex.transaction (transaction) =>
      Promise.bind(@)
      .then -> strategy.start(transaction)
      .then -> strategy.insert(sample)
      .then -> strategy.finish()
    .then ->
      knex(_3DCartCategories::tableName).count("id")
      .then (results) ->
        results[0].count.should.be.equal("1")
    .then ->
      _3DCartCategories.where({CategoryName: "Bellefit Girdles"}).fetch()
      .then (model) ->
        should.exist(model)

  it "should update existing objects @fast", ->
    Promise.bind(@)
    .then ->
      knex.transaction (transaction) =>
        strategy = new _3DCartSaveCategories(
          _.defaults {}, input
        ,
          dependencies
        )
        Promise.bind(@)
        .then -> strategy.start(transaction)
        .then -> strategy.insert(sample)
        .then -> strategy.finish()
    .then ->
      knex.transaction (transaction) =>
        strategy = new _3DCartSaveCategories(
          _.defaults {}, input
        ,
          dependencies
        )
        Promise.bind(@)
        .then -> strategy.start(transaction)
        .then -> strategy.insert _.defaults
          CategoryName: "New Category Name"
        , sample
        .then -> strategy.finish()
    .then ->
      knex(_3DCartCategories::tableName).count("id")
      .then (results) ->
        results[0].count.should.be.equal("1")
    .then ->
      _3DCartCategories.where({CategoryName: "New Category Name"}).fetch()
      .then (model) ->
        should.exist(model)