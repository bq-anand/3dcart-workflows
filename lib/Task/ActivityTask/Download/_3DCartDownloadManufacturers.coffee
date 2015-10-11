_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
_3DCartReadManufacturers = require "../../../Strategy/APIStrategy/Read/LimitOffset/_3DCartReadManufacturers"
_3DCartSaveManufacturers = require "../../../Strategy/DBStrategy/Save/TemporaryTable/_3DCartSaveManufacturers"

# This task leaks memory. Maybe it's promises, but who knows
class _3DCartDownloadManufacturers extends Download
  constructor: (input, options, dependencies) ->
    Match.check input, Match.ObjectIncluding
      _3DCartReadManufacturers: Object
      _3DCartSaveManufacturers: Object
    super

  createReadStrategy: -> new _3DCartReadManufacturers @_3DCartReadManufacturers, @dependencies
  createSaveStrategy: -> new _3DCartSaveManufacturers @_3DCartSaveManufacturers, @dependencies


module.exports = _3DCartDownloadManufacturers
