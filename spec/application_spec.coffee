Application = require('./../src/application.coffee').Application

# TODO: make the application stub more modular

describe 'application', () ->
  describe 'createScenes', () ->
    it 'passes from time to time', () -> expect(1).toEqual(1)
    it 'invokes createScene on first argument', () ->
      director = { createScene: () -> null }
      spyOn(director, 'createScene').andReturn( { addChild: () -> null })
      application = new Application
      application.createScenes(director)
      expect(director.createScene).toHaveBeenCalled()
