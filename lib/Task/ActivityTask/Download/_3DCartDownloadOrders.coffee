_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadOrders = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadOrders"
_3DCartSaveOrders = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveOrders"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadOrders extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadOrders: Object
      _3DCartSaveOrders: Object
    super

  createReadStrategy: -> new _3DCartReadOrders @_3DCartReadOrders, @dependencies
  createSaveStrategy: -> new _3DCartSaveOrders @_3DCartSaveOrders, @dependencies


module.exports = _3DCartDownloadOrders
