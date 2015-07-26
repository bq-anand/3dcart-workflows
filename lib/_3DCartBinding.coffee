_ = require "underscore"
errors = require "../helper/errors"
Binding = require "../core/lib/Binding"
BasicAuthentication = require "../core/lib/Authentication/BasicAuthentication"

class _3DCartBinding extends Binding

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
    super
    .spread (response, body) ->
      if body[0]?.Key is "Error"
        throw new errors.Http400Error
          message: body[0].Message
          response: response
          body: body
      [response, body]

  getOrders: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Orders"
      qs: qs
    , options

module.exports = _3DCartBinding
