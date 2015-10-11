_ = require "underscore"
stamp = require "../../../core/helper/stamp"
DecisionTask = require "../../../core/lib/Task/DecisionTask"

class _3DCartDownloadDatabase extends DecisionTask
  WorkflowExecutionStarted: (event, attributes, input) ->
    @input = input
    @createBarrier "CompleteWorkflowExecution", [
      "_3DCartDownloadDistributors"
      "_3DCartDownloadCategories"
      "_3DCartDownloadCustomerGroups"
      "_3DCartDownloadCustomers"
      "_3DCartDownloadManufacturers"
      "_3DCartDownloadOrders"
      "_3DCartDownloadProducts"
    ]
    @addDecision @ScheduleActivityTask "_3DCartDownloadDistributors", stamp(@input["_3DCartDownloadDistributors"], @input)
    @addDecision @ScheduleActivityTask "_3DCartDownloadCategories", stamp(@input["_3DCartDownloadCategories"], @input)
    @addDecision @ScheduleActivityTask "_3DCartDownloadCustomerGroups", stamp(@input["_3DCartDownloadCustomerGroups"], @input)
    @addDecision @ScheduleActivityTask "_3DCartDownloadCustomers", stamp(@input["_3DCartDownloadCustomers"], @input)
    @addDecision @ScheduleActivityTask "_3DCartDownloadManufacturers", stamp(@input["_3DCartDownloadManufacturers"], @input)
    @addDecision @ScheduleActivityTask "_3DCartDownloadOrders", stamp(@input["_3DCartDownloadOrders"], @input)
    @addDecision @ScheduleActivityTask "_3DCartDownloadProducts", stamp(@input["_3DCartDownloadProducts"], @input)

  CompleteWorkflowExecutionBarrierPassed: ->
    @addDecision @CompleteWorkflowExecution @results

module.exports = _3DCartDownloadDatabase
