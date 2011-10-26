class Application
  #  This function will be called to let you define new scenes that will be
  #  shown after the splash screen.
  createScenes: (director) ->
    scene = director.createScene()
    scene.addChild(
      new CAAT.ShapeActor()
      .setShape(CAAT.ShapeActor.prototype.SHAPE_CIRCLE)
      .setLocation(325,225)
      .setSize(50,50)
      .setFillStyle('rgb(0,0,0)')
    )

# Startup it all up when the document is ready.
# Change for your favorite frameworks initialization code.
window?.addEventListener( 'load', () -> 
  application = new Application
  CAAT.modules.initialization.init(
    # canvas will be 800x600 pixels
    700, 500,

    # and will be added to the end of document. set an id of a canvas or div
    # element
    undefined,
    
    # load these images and set them up for non splash scenes.
    # image elements must be of the form:
    # {id:'<unique string id>',    url:'<url to image>'}
    #
    # No images can be set too.
    [
    ],

    # onEndSplash callback function.
    # Create your scenes on this method.
    application.createScenes
  )
)

(exports ? this).Application = Application
