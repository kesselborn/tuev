QUnit.log = function(result_object, qunit_message) {
  message =  result_object.result ? "ok      " : "FAILED  ";
  message += result_object.message;
  if(!result_object.result && result_object.expected){
    message += "\n-----------------------8<-------------------------"
    message += "\nexpected: " + result_object.expected;
    message += "\nbut got:  " + result_object.actual;
    message += "\nsource:   " + result_object.source;
    message += "\n----------------------->8-------------------------\n"
    window.errors.push(message);
  }
  window.results.push(message);

  if (window.console && window.console.log) {
    window.console.log(message);
  }                                            
}; 
if(!window.results) {
  window.results = [];
}
if(!window.errors) {
  window.errors = [];
}
