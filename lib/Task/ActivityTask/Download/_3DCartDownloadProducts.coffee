_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadProducts = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadProducts"
_3DCartSaveProducts = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveProducts"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadProducts extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadProducts: Object
      _3DCartSaveProducts: Object
    super

  createReadStrategy: -> new _3DCartReadProducts @_3DCartReadProducts, @dependencies
  createSaveStrategy: -> new _3DCartSaveProducts @_3DCartSaveProducts, @dependencies


module.exports = _3DCartDownloadProducts
