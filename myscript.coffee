#
# TODO:
# - [x] show current running status
# - [x] allow one to run against tags
# - [x] allow one to run against envs
#

# insert rainforest holder div
$('.discussion-timeline-actions').before(@holderTmpl())

makeAjaxRequest = (options) ->
  $.ajax
    type: options.type || "GET"
    url: "https://app.rainforestqa.com/api/1/#{options.endpoint}"
    dataType: "json"
    data: options.data || {}
    headers:
      CLIENT_TOKEN: "08b8bc4f0cec845a37f9266918e83e98"
    success: (data) => options.success?(data)

renderRun = (run) ->
  $(".rainforest-run-history").append @runHistoryItemTmpl(run)

# get client so we can see what is currently running
makeAjaxRequest
  endpoint: "runs"
  data: {state: "in_progress"}
  success: (data) => renderRun(run) for run, i in data

# get envs
makeAjaxRequest 
  endpoint: "environments"
  success: (data) ->
    for env, i in data
      selected = if env.default is true then "selected" else ""
      $('.rainforest-envs').append "<option value='#{env.id}' #{selected}>#{env.name}</option>"

# get tags
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
    success: (data) => renderRun(data)