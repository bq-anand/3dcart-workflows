_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadOrders = require "../BindingTask/Read/_3DCartReadOrders"
_3DCartSaveOrders = require "../Save/_3DCartSaveOrders"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadOrders extends Download
  constructor: (input, options, streams, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadOrders: Object
      _3DCartSaveOrders: Object
    readArguments = @arguments input, "_3DCartReadOrders"
    saveArguments = @arguments input, "_3DCartSaveOrders"
    _.extend @,
      read: new _3DCartReadOrders readArguments.input, readArguments.options, streams, dependencies
      save: new _3DCartSaveOrders saveArguments.input, saveArguments.options, streams, dependencies
    super

module.exports = _3DCartDownloadOrders
