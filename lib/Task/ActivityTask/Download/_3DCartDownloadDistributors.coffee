_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadDistributors = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadDistributors"
_3DCartSaveDistributors = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveDistributors"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadDistributors extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadDistributors: Object
      _3DCartSaveDistributors: Object
    super

  createReadStrategy: -> new _3DCartReadDistributors @_3DCartReadDistributors, @dependencies
  createSaveStrategy: -> new _3DCartSaveDistributors @_3DCartSaveDistributors, @dependencies


module.exports = _3DCartDownloadDistributors
