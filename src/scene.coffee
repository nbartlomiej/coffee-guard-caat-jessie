class Scene extends CAAT.Scene
  constructor: ->
    super
    testShape = new CAAT.ShapeActor()
      .setShape(CAAT.ShapeActor.prototype.SHAPE_CIRCLE)
      .setLocation(325,225)
      .setSize(50,50)
      .setFillStyle('rgb(0,0,0)')
    @addChild(testShape)

(exports ? this).Scene = Scene
