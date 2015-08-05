_ = require "underscore"
stamp = require "../../../core/helper/stamp"
DecisionTask = require "../../../core/lib/Task/DecisionTask"

class _3DCartWriteOrderInternalComment extends DecisionTask
  WorkflowExecutionStarted: (event, attributes, input) ->
    @input = input
    @createBarrier "CompleteWorkflowExecution", ["_3DCartWriteOrderInternalComment"]
    @addDecision @ScheduleActivityTask "_3DCartWriteOrderInternalComment", stamp(@input["_3DCartWriteOrderInternalComment"], @input)

  CompleteWorkflowExecutionBarrierPassed: ->
    @addDecision @CompleteWorkflowExecution success: true

module.exports = _3DCartWriteOrderInternalComment
