var jessie = require('jessie')
jessie.sugar()

// Stubs for DOM objects (not present in node).

navigator = {
  userAgent: "node-js", appVersion: "none"
};

window = {
  setTimeout: function(){},
  addEventListener: function(){}
};

document = {

  createElement: function(){ return {
    getContext: function(){ return {
      globalAlpha:  function(){},
      clearRect:    function(){},
      save:         function(){},
      setTransform: function(){},
      beginPath:    function(){},
      arc:          function(){},
      restore:      function(){},
      fill:         function(){}
    }; },

    addEventListener: function(){},
    appendChild:      function(){}
  }; },

  body: {
    appendChild: function(){},
    globalAlpha: function(){}
  }

};

// Globally requiring CAAT.

CAAT = require('./../lib/caat.js').CAAT;

// Custom Jasmine matchers.

beforeEach(function() {
  this.addMatchers({
    toBeArray:  function() { return this.actual instanceof Array; },
    toBeNumber: function() { return typeof(this.actual) === "number"; },
  });
});

// We are using CoffeeScript

require('coffee-script');
