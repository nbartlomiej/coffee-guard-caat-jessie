Scene = require('./../src/scene.coffee').Scene if exports?

class Application

  constructor: (document) ->
    @width  = 700
    @height = 500
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
    director = new CAAT.Director()
      .initialize(@width, @height, undefined)
    canvasContainer.appendChild( director.canvas );
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

        CAAT.loop(60);
    );

window?.addEventListener( 'load', -> 
  application = new Application(document)
  application.run()
)

(exports ? this).Application = Application
