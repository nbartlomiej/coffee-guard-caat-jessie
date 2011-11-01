Scene   = require('./../src/scene.coffee').Scene

describe 'Scene', () ->
  describe 'constructor', () ->
    it 'works', ()->
      scene = new Scene({10, 10, 'test'})
