_ = require "underscore"
errors = require "../helper/errors"
CommonBinding = require "../core/lib/Binding"
BasicAuthentication = require "../core/lib/Authentication/BasicAuthentication"

class Binding extends CommonBinding

  request: (options) ->
    _.defaults options,
      baseUrl: "https://apirest.3dcart.com/3dCartWebAPI/v1"
      json: true
      headers: {}
    # 3DCart uses a homegrown authentication mechanism
    _.defaults options.headers,
      SecureUrl: @credential.url
      PrivateKey: @credential.privateKey
      Token: @credential.token
    # TODO: find out how 3DCart responds with rate limit error
    super(options)
#    super(options).spread (response, body) ->
#      if response.statusCode is 403
#        throw new errors.RateLimitReachedError
#          response: response
#          body: body
#      [response, body]

  getOrders: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Orders"
      qs: qs
    , options

module.exports = Binding
