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
      baseUrl: "#{if @credential.details.noProxy then "https" else "http"}://apirest.3dcart.com/3dCartWebAPI/v1" # sorry for noProxy hack, but the full-fledged implementation requires a Redis rate limiter
      json: true
      headers: {}
    # 3DCart uses a homegrown authentication mechanism
    _.defaults options.headers,
      SecureUrl: @credential.details.url
      PrivateKey: @credential.details.privateKey
      Token: @credential.details.token
    super
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

  updateOrders: (json, options) ->
    @request _.extend
      method: "PUT"
      url: "/Orders"
      json: json
    , options

  getCustomerGroups: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/CustomerGroups"
      qs: qs
    , options

  getCustomers: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Customers"
      qs: qs
    , options

  getDistributors: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Distributors"
      qs: qs
    , options

  getCategories: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Categories"
      qs: qs
    , options

  getProducts: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Products"
      qs: qs
    , options

  getManufacturers: (qs, options) ->
    @request _.extend
      method: "GET"
      url: "/Manufacturers"
      qs: qs
    , options

module.exports = _3DCartBinding
