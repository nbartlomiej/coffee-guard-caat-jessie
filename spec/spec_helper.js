var jessie = require('jessie')
jessie.sugar()

require('coffee-script');

navigator = { userAgent: "node-js" };
window    = { addEventListener: function(){} }
CAAT      = require('./../lib/caat.js').CAAT
