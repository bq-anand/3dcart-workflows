_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadOrders = require "../BindingTask/Read/_3DCartReadOrders"
_3DCartSaveOrders = require "../Save/_3DCartSaveOrders"

class _3DCartDownloadOrders extends Download
  constructor: (input, options, streams, dependencies) ->
    Match.check input,
      _3DCartReadOrders: Object
      _3DCartSaveOrders: Object
    _.extend @,
      read: new _3DCartReadOrders input._3DCartReadOrders.input, input._3DCartReadOrders, streams, dependencies
      save: new _3DCartSaveOrders input._3DCartSaveOrders.input, input._3DCartReadOrders, streams, dependencies
    super

module.exports = _3DCartDownloadOrders