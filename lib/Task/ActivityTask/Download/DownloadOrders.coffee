_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
ReadOrders = require "../Read/ReadOrders"
SaveOrders = require "../Save/SaveOrders"

class DownloadOrders extends Download
  constructor: (options, dependencies) ->
    Match.check options,
      ReadOrders: Object
      SaveOrders: Object
    super options, _.extend {}, dependencies,
      read: new ReadOrders options.ReadOrders, dependencies
      save: new SaveOrders options.SaveOrders, dependencies

module.exports = DownloadOrders