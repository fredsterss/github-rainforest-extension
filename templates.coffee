# Holder Template
@holderTmpl = ->
  return "
  <div class='rainforest-info-holder'>
    <ul class='rainforest-complete-runs'></ul>
    <ul class='rainforest-in-progress-runs'></ul>

    <label>Env:</label>
    <select class='rainforest-envs'></select>

    <label>Tag:</label>
    <select class='rainforest-tags'>
      <option value='all'>All tests</option>
    </select>

    <button class='btn run-rainforest'>Run Rainforest Suite</button>
  </div>"

@completeRunsTmpl = ->
  return "<p class= 'rainforest-complete-title'>recent Rainforest tests:</p>"

@inProgressRunsTmpl = ->
  return "<p class='rainforest-in-progress-title'>in progress Rainforest tests:</p>"

@runHistoryItemTmpl = (run) ->
  length = run.requested_tests.length
  tagText = ""
  if run.filters.tags?
    for tag, i in run.filters.tags
      tagText = "#{tagText} ##{tag}"
      tagText = "#{tagText}, " if i > 0

  return "
    <li>
      <code>
        <a href='#{run.frontend_url}'>#{run.id}</a>: 
        #{length} #{tagText} test#{if length > 1 then "s" else ""} against #{run.environment.name}.
        Run #{run.state}, #{run.result}.
      </code>
    </li>"
