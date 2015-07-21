_ = require "underscore"
Promise = require "bluebird"
Binding = require "../../lib/Binding"
settings = (require "../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

describe "Binding", ->
  @timeout(10000) if process.env.NOCK_BACK_MODE is "record"

  binding = null

  beforeEach ->
    binding = new Binding
      credential: settings.credentials.bellefit

  it "binding.getOrders() :: GET /Orders", ->
    new Promise (resolve, reject) ->
      nock.back "test/fixtures/Binding/getOrders.json", (recordingDone) ->
        binding.getOrders
          offset: 0
          limit: 10
        .spread (response, body) ->
          console.log body
          # check body before response to make the test runner show more info in case of an error
          body.should.be.an("array")
          body.length.should.be.equal(10)
          body.should.all.have.property("OrderID")
          response.statusCode.should.be.equal(200)
        .then resolve
        .catch reject
        .finally recordingDone

#  it "binding should report rate limiting errors @ratelimit", (testDone) ->
#    binding
#    testDone()
#
