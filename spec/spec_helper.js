var jessie = require('jessie');
jessie.sugar();

// TODO: switch to including the third party JavaScript files (in the same way
// browser does) and erase code appended to third party JavaScript files
// maybe use the script below:
// function include(path) {
//   var promise = new process.Promise();
//   posix.cat(path).addCallback(function (data) {
//     promise.emitSuccess(eval(data));
//   }).addErrback(function () {
//     promise.emitError();
//   });
//   return promise;
// }

// Stubs for DOM objects (not present in node).

navigator = {
  userAgent: "node-js", appVersion: "none"
};

window = {
  setTimeout: function(){},
  addEventListener: function(){}
};

var elementStub = function(){ return {
  style: {},
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
}; };

document = {
  getElementById: elementStub,
  createElement: elementStub,
  body: {
    appendChild: function(){},
    globalAlpha: function(){}
  }
};

// Globally requiring CAAT.

CAAT = require('./../lib/caat-css.js').CAAT;

// use the following script to work with Canvas
// CAAT = require('./../lib/caat-css.js').CAAT;

// Custom Jasmine matchers.

beforeEach(function() {
  this.addMatchers({
    toBeArray:  function() { return this.actual instanceof Array; },
    toBeNumber: function() { return typeof(this.actual) === "number"; },
  });
});

// We are using CoffeeScript

require('coffee-script');
