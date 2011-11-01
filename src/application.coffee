class Application

  constructor: (document) ->
    @width  = 700
    @height = 500
    @scenes     = []
    @imagesUrls = []
    @director = @embedApplication(document)

  createScenes: (director) ->
    scene = director.createScene()
    scene.addChild(
      new CAAT.ShapeActor()
      .setShape(CAAT.ShapeActor.prototype.SHAPE_CIRCLE)
      .setLocation(325,225)
      .setSize(50,50)
      .setFillStyle('rgb(0,0,0)')
    )

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
