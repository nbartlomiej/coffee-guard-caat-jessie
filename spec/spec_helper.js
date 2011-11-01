var jessie = require('jessie')
jessie.sugar()

require('coffee-script');

navigator = {
  userAgent: "node-js", appVersion: "none"
};

window = {
  setTimeout: function(){},
  addEventListener: function(){}
};
CAAT = require('./../lib/caat.js').CAAT;
document = {
  createElement: function(){ return {
    addEventListener: function(){},
    appendChild: function(){},
    getContext: function(){ return {
      globalAlpha: function(){},
      clearRect: function(){},
      save: function(){},
      setTransform: function(){},
      beginPath: function(){},
      arc: function(){},
      restore: function(){},
      fill: function(){}
    }; }
  }; },
  body: {
    appendChild: function(){},
    globalAlpha: function(){}
  }
};

beforeEach(function() {
  this.addMatchers({
    toBeArray:  function() { return this.actual instanceof Array; },
    toBeNumber: function() { return typeof(this.actual) === "number"; },
  });
});
