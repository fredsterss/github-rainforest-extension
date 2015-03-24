// Generated by CoffeeScript 1.9.0
(function() {
  var ajaxHelper;

  $('.discussion-timeline-actions').before("<div class='rainforest-info-holder'> <p>Current runs:</p> <ul class='rainforest-run-history'></ul> <button class='btn run-rainforest'>Run Rainforest Suite</button> </div>");

  ajaxHelper = function(type, endpoint, data, cb) {
    return $.ajax({
      type: type,
      url: "https://app.rainforest.dev/api/1/" + endpoint,
      dataType: "json",
      data: data,
      headers: {
        CLIENT_TOKEN: "08b8bc4f0cec845a37f9266918e83e98"
      },
      success: (function(_this) {
        return function(data) {
          return typeof cb === "function" ? cb(data) : void 0;
        };
      })(this)
    });
  };

  ajaxHelper("GET", "runs", {
    state: "complete"
  }, (function(_this) {
    return function(data) {
      var i, run, _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = data.length; _i < _len; i = ++_i) {
        run = data[i];
        _results.push($(".rainforest-run-history").append("<li> <code> <a href='" + run.frontend_url + "'>run " + run.id + "</a>: " + run.requested_tests.length + " tests against " + run.environment.name + ". Run " + run.result + ". </code> </li>"));
      }
      return _results;
    };
  })(this));

  $('.run-rainforest').on("click", (function(_this) {
    return function() {
      return ajaxHelper("POST", "runs", {
        tests: "all"
      }, function(data) {
        return console.log("hai lul", data);
      });
    };
  })(this));

}).call(this);
