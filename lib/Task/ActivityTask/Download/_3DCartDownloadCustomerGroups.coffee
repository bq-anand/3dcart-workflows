_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadCustomerGroups = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadCustomerGroups"
_3DCartSaveCustomerGroups = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveCustomerGroups"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadCustomerGroups extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadCustomerGroups: Object
      _3DCartSaveCustomerGroups: Object
    super

  createReadStrategy: -> new _3DCartReadCustomerGroups @_3DCartReadCustomerGroups, @dependencies
  createSaveStrategy: -> new _3DCartSaveCustomerGroups @_3DCartSaveCustomerGroups, @dependencies


module.exports = _3DCartDownloadCustomerGroups
