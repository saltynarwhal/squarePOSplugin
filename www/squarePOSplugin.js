// Empty constructor
function squarePOSplugin() {}

// The function that passes work along to native shells
// Message is a string, duration may be 'long' or 'short'
squarePOSplugin.prototype.startTransaction = function(jobid, successCallback, errorCallback) {
  var options = {};
  options.jobid = jobid;
  cordova.exec(successCallback, errorCallback, 'squarePOSplugin', 'startTransaction', [options]);
}

// Installation constructor that binds ToastyPlugin to window
squarePOSplugin.install = function() {
  if (!window.plugins) {
    window.plugins = {};
  }
  window.plugins.squarePOSplugin = new squarePOSplugin();
  return window.plugins.squarePOSplugin;
};
cordova.addConstructor(squarePOSplugin.install);
