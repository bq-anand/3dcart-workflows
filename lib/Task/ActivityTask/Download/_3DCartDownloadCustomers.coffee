_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadCustomers = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadCustomers"
_3DCartSaveCustomers = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveCustomers"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadCustomers extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadCustomers: Object
      _3DCartSaveCustomers: Object
    super

  createReadStrategy: -> new _3DCartReadCustomers @_3DCartReadCustomers, @dependencies
  createSaveStrategy: -> new _3DCartSaveCustomers @_3DCartSaveCustomers, @dependencies


module.exports = _3DCartDownloadCustomers
