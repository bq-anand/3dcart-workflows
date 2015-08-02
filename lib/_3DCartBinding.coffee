_ = require "underscore"
errors = require "../helper/errors"
Binding = require "../core/lib/Binding"
BasicAuthentication = require "../core/lib/Authentication/BasicAuthentication"

class _3DCartBinding extends Binding
  constructor: (options) ->
    _.defaults options,
      api: "_3DCart"
    super

  request: (options) ->
    _.defaults options,
      baseUrl: "https://apirest.3dcart.com/3dCartWebAPI/v1"
      json: true
      headers: {}
    # 3DCart uses a homegrown authentication mechanism
    _.defaults options.headers,
      SecureUrl: @credential.details.url
      PrivateKey: @credential.details.privateKey
      Token: @credential.details.token
    super
    .spread @checkStatusCode
    .spread (response, body) ->
      if body[0]?.Key is "Error"
        throw new errors.RuntimeError
          message: body[0].Message
          response: response.toJSON()
          body: body
      [response, body]

  getOrders: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Orders"
      qs: qs
    , options

module.exports = _3DCartBinding
