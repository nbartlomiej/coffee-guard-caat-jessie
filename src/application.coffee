class Application

  constructor: ->
    this.scenes = []
    this.width  = 700
    this.height = 500
    this.imagesUrls = []
    this.director = this.embedApplication(document)

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
    this.canvasContainer = document.createElement('div');
    document.body.appendChild(this.canvasContainer);
    this.canvasContainer

  embedApplication: (document) ->
    canvasContainer = this.createCanvasContainer(document)    
    director = new CAAT.Director()
      .initialize(this.width, this.height, undefined)
    canvasContainer.appendChild( director.canvas );
    director

  run: (document) ->
    new CAAT.ImagePreloader().loadImages( this.imagesUrls, (counter, images) =>
      if counter==images.length
        this.director.emptyScenes();
        this.director.setImagesCache(images);
        this.createScenes(this.director);

        this.director.easeIn(
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
