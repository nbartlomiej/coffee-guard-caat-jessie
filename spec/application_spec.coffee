Application = require('./../src/application.coffee').Application

describe 'application', ->
  application = null

  beforeEach ->
    application = new Application(document)

  describe 'constructor', ->
    it 'initializes list of scenes', ->
      expect(application.scenes).toBeArray()
    it 'initializes width and height', ->
      expect(application.width).toBeNumber()
      expect(application.height).toBeNumber()

  describe 'imagesUrls', ->
    it 'is an array', ->
      expect(application.imagesUrls).toBeArray()

  describe 'run()', ->
    it 'takes document as the only parameter', ->
      document = {createElement: -> null}
      application.run(document)

