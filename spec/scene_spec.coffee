Scene   = require('./../src/scene.coffee').Scene

describe 'Scene', () ->
  describe 'constructor', () ->
    it 'works', ()->
      scene = new Scene({}) # empty configuration
