#
# Helper functions
#

# generic ajax call helper
makeAjaxRequest = (options) ->
  $.ajax
    type: options.type || "GET"
    url: "https://app.rainforestqa.com/api/1/#{options.endpoint}"
    dataType: "json"
    data: options.data || {}
    headers:
      CLIENT_TOKEN: "08b8bc4f0cec845a37f9266918e83e98"
    success: (data) => options.success?(data)

renderRun = (run, key) ->
  tmpl = if key is "complete" then @completeRunsTmpl else @inProgressRunsTmpl
  $(".rainforest-#{key}-runs").before(tmpl()) unless $(".rainforest-#{key}-title").length
  $(".rainforest-#{key}-runs").append @runHistoryItemTmpl(run)

addPoller = (options) ->
  console.log "polling", options

#
# Build UI
#

# insert rainforest holder div
$('.discussion-timeline-actions').before(@holderTmpl())

# get and render current runs
makeAjaxRequest
  endpoint: "runs"
  data:
    state: "in_progress"
  success: (data) =>
    renderRun(run, "in-progress") for run, i in data
    addPoller(endpoint: "runs", state: "in_progress") if data.length > 0

# get and render recent runs
makeAjaxRequest
  endpoint: "runs"
  data:
    state: "complete"
    page_size: 5
  success: (data) => renderRun(run, "complete") for run, i in data

# get and render env options
makeAjaxRequest 
  endpoint: "environments"
  success: (data) ->
    for env, i in data
      selected = if env.default is true then "selected" else ""
      $('.rainforest-envs').append "<option value='#{env.id}' #{selected}>#{env.name}</option>"

# get and render tag options
makeAjaxRequest 
  endpoint: "tests/tags"
  success: (data) ->
    for tag, i in data
      $('.rainforest-tags').append "<option value='#{tag.name}'>#{tag.name}</option>"

# add listener to run rainforest button
$('.run-rainforest').on "click", ->
  env = $('.rainforest-envs').val()
  tag = $('.rainforest-tags').val()

  requestOptions = {environment_id: env}
  if tag is "all"
    requestOptions["tests"] = "all"
  else
    requestOptions["tags"] = [tag]
  
  makeAjaxRequest
    type: "POST"
    endpoint: "runs"
    data: requestOptions
    success: (data) =>
      renderRun(data, "in-progress")
      addPoller endpoint: "runs", data: {state: "in_progress"}