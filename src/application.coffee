Scene = require('./../src/scene.coffee').Scene if exports?

class Configuration
  constructor: (@width, @height, @os) ->

class Application

  constructor: (document) ->
    @width  = 320
    @height = 480
    @director = @embedApplication(document)

    @imagesUrls = []
    @configuration = new Configuration( @width, @height, @director.getOSName())
    @scenes     = [new Scene(@configuration)]

  createScenes: (director) ->
    director.addScene(@scenes.pop())

  getCanvasContainer: (document) ->
    canvasContainer = document.getElementById('application');

  embedApplication: (document) ->
    canvasContainer = @getCanvasContainer(document)    
    # trying the html5 canvas approach
    try
      director = new CAAT.Director().initialize(@width, @height, undefined)
      canvasContainer.appendChild( director.canvas );
    # if not, switching to css
    catch error
      director = new CAAT.Director().initialize(@width, @height, canvasContainer)

    director

  run: (document) ->
    new CAAT.ImagePreloader().loadImages( @imagesUrls, (counter, images) =>
      if counter==images.length
        @director.emptyScenes();
        @director.setImagesCache(images);
        @createScenes(@director);

        CAAT.loop(60);
    );

window?.addEventListener( 'load', -> 
  application = new Application(document)
  application.run()
)

(exports ? this).Application = Application
