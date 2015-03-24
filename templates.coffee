# Holder Template
@holderTmpl = -> 
  return "
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
  </div>"

@runHistoryItemTmpl = (run) ->
  return "
    <li>
      <code>
        <a href='#{run.frontend_url}'>run #{run.id}</a>: 
        #{run.requested_tests.length} tests against #{run.environment.name}.
        Run #{run.state}, #{run.result}.
      </code>
    </li>"
