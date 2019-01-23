// Empty constructor
function squarePOSplugin() {}

// The function that passes work along to native shells
// Message is a string, duration may be 'long' or 'short'
squarePOSplugin.prototype.startTransaction = function(successCallback, errorCallback) {
  cordova.exec(successCallback, errorCallback, 'squarePOSplugin', 'startTransaction');
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
