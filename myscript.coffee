$('.branch-action').before("<button class='btn run-rainforest'>Run Rainforest Suite</button>")
$('.run-rainforest').on "click", =>
  $.ajax
    type: "POST"
    url: "https://app.rainforest.dev/api/1/runs"
    dataType: "json"
    data:
      tests: "all"
    headers:
      CLIENT_TOKEN: "08b8bc4f0cec845a37f9266918e83e98"
    success: (data) => console.log data