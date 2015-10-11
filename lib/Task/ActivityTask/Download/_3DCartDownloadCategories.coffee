_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadCategories = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadCategories"
_3DCartSaveCategories = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveCategories"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadCategories extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadCategories: Object
      _3DCartSaveCategories: Object
    super

  createReadStrategy: -> new _3DCartReadCategories @_3DCartReadCategories, @dependencies
  createSaveStrategy: -> new _3DCartSaveCategories @_3DCartSaveCategories, @dependencies


module.exports = _3DCartDownloadCategories
