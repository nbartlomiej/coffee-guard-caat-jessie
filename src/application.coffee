Scene = require('./../src/scene.coffee').Scene if exports?

class Application

  constructor: (document) ->
    @height  = 480
    @width = 320
    @scenes     = [new Scene]
    @imagesUrls = []
    @director = @embedApplication(document)

  createScenes: (director) ->
    director.addScene(@scenes.pop())

  createCanvasContainer: (document) ->
    canvasContainer = document.createElement('div');
    document.body.appendChild(canvasContainer);
    canvasContainer

  embedApplication: (document) ->
    canvasContainer = @createCanvasContainer(document)    
    # trying the canvas approach
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

        @director.easeIn(
          0,
          CAAT.Scene.prototype.EASE_SCALE,
          2000,
          false,
          CAAT.Actor.prototype.ANCHOR_CENTER,
          new CAAT.Interpolator().createElasticOutInterpolator(2.5, .4)
        );

        CAAT.loop(30);
    );

window?.addEventListener( 'load', -> 
  application = new Application(document)
  application.run()
)

(exports ? this).Application = Application
