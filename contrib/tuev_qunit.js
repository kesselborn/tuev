QUnit.log = function(result, message) {
    if (window.console && window.console.log) {
      window.console.log(result +' :: '+ result.message);
    }
};

