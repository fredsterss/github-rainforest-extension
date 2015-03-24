#
# TODO:
# - [x] show current running status
# - [x] allow one to run against tags
# - [x] allow one to run against envs
#

# insert rainforest holder div
$('.discussion-timeline-actions').before("
  <div class='rainforest-info-holder'>
    <p>Current in progress runs:</p>
    <ul class='rainforest-run-history'></ul>

    <p>Run your tests:</p>
    <label>Env:</label>
    <select class='rainforest-envs'></select>

    <label>Tag:</label>
    <select class='rainforest-tags'>
      <option value='all'>All tests</option>
    </select>
    <br>
    <button class='btn run-rainforest'>Run Rainforest Suite</button>
  </div>")

ajaxHelper = (type, endpoint, data, cb) ->
  $.ajax
    type: type
    url: "https://app.rainforest.dev/api/1/#{endpoint}"
    dataType: "json"
    data: data
    headers:
      CLIENT_TOKEN: "08b8bc4f0cec845a37f9266918e83e98"
    success: (data) => cb?(data)

renderRun = (run) ->
  $(".rainforest-run-history").append "
    <li>
      <code>
        <a href='#{run.frontend_url}'>run #{run.id}</a>: 
        #{run.requested_tests.length} tests against #{run.environment.name}.
        Run #{run.state}, #{run.result}.
      </code>
    </li>"

# get client so we can see what is currently running
ajaxHelper "GET", "runs", {state: "in_progress"}, (data) => renderRun(run) for run, i in data

# get envs
ajaxHelper "GET", "environments", {}, (data) =>
  for env, i in data
    selected = if env.default is true then "selected" else ""
    $('.rainforest-envs').append "<option value='#{env.id}' #{selected}>#{env.name}</option>"

# get tags
ajaxHelper "GET", "tests/tags", {}, (data) =>
  for tag, i in data
    $('.rainforest-tags').append "<option value='#{tag.name}'>#{tag.name}</option>"

# add listener to run rainforest button
$('.run-rainforest').on "click", =>
  env = $('.rainforest-envs').val()
  tag = $('.rainforest-tags').val()

  requestOptions = {environment_id: env}
  if tag is "all"
    requestOptions["tests"] = "all"
  else
    requestOptions["tags"] = [tag]
  
  ajaxHelper "POST", "runs", requestOptions, (data) => renderRun(data)