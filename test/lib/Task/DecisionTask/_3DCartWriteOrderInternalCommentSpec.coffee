_ = require "underscore"
Promise = require "bluebird"
stream = require "readable-stream"
input = require "../../../../core/test-helper/input"
createDependencies = require "../../../../core/helper/dependencies"
settings = (require "../../../../core/helper/settings")("#{process.env.ROOT_DIR}/settings/dev.json")

WorkflowExecutionHistoryGenerator = require "../../../../core/lib/WorkflowExecutionHistoryGenerator"
_3DCartWriteOrderInternalComment = require "../../../../lib/Task/DecisionTask/_3DCartWriteOrderInternalComment"

describe "_3DCartWriteOrderInternalComment decision task", ->
  dependencies = createDependencies(settings, "_3DCartWriteOrderInternalComment_dec")

  generator = new WorkflowExecutionHistoryGenerator()

  generator.seed ->
    [
      events: [
        @WorkflowExecutionStarted _.defaults
          "_3DCartWriteOrderInternalComment":
            avatarId: "T7JwArn9vCJLiKXbn"
            params: {}
        , input
      ]
      decisions: [
        @ScheduleActivityTask "_3DCartWriteOrderInternalComment", _.defaults
          avatarId: "T7JwArn9vCJLiKXbn"
          params: {}
        , input
      ]
      updates: [@commandSetIsStarted input.commandId]
      branches: [
        events: [@ActivityTaskCompleted "_3DCartWriteOrderInternalComment"]
        decisions: [@CompleteWorkflowExecution({success: true})]
        updates: [
          @commandSetIsCompleted input.commandId
          @commandSetResult input.commandId, {success: true}
        ]
      ,
        events: [@ActivityTaskFailed "_3DCartWriteOrderInternalComment"]
        decisions: [@FailWorkflowExecution()]
        updates: [@commandSetIsFailed input.commandId]
      ]
    ]

  for history in generator.histories()
    do (history) ->
      it "should run `#{history.name}` history", ->
        task = new _3DCartWriteOrderInternalComment(
          history.events
        ,
          {}
        ,
          dependencies
        )
        task.execute()
        .then ->
          task.decisions.should.be.deep.equal(history.decisions)
          task.updates.should.be.deep.equal(history.updates)
