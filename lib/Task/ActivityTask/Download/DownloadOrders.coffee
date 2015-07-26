_ = require "underscore"
Promise = require "bluebird"
Match = require "mtr-match"
Download = require "../../../../core/lib/Task/ActivityTask/Download"
ReadOrders = require "../Read/ReadOrders"
SaveOrders = require "../Save/SaveOrders"

class DownloadOrders extends Download
  constructor: (input, options, dependencies) ->
    Match.check input,
      ReadOrders: Object
      SaveOrders: Object
    super input, options, _.extend {}, dependencies,
      read: new ReadOrders input.ReadOrders.input, input.ReadOrders, dependencies
      save: new SaveOrders input.SaveOrders.input, input.SaveOrders, dependencies

module.exports = DownloadOrders