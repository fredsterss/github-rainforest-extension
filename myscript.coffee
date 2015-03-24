#
# TODO:
# - [ ] show current running status
# - [ ] allow one to run against tags
# - [ ] allow one to run against envs
#

# insert rainforest holder div
$('.discussion-timeline-actions').before("
  <div class='rainforest-info-holder'>
    <p>Current runs:</p>
    <ul class='rainforest-run-history'></ul>
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

# get client so we can see what is currently running
ajaxHelper "GET", "runs", {state: "complete"}, (data) =>
  for run, i in data
    $(".rainforest-run-history").append "
      <li>
        <code>
          <a href='#{run.frontend_url}'>run #{run.id}</a>: 
          #{run.requested_tests.length} tests against #{run.environment.name}.
          Run #{run.result}.
        </code>
      </li>"

# add listener to run rainforest button
$('.run-rainforest').on "click", =>
  ajaxHelper "POST", "runs", {tests: "all"}, (data) => console.log "hai lul", data