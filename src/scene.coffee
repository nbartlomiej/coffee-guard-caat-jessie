class Scene extends CAAT.Scene
  constructor: ->
    super

    @hero = new Player
    @hero.setLocation(150,230)
    @addChild(@hero)

    new KeyboardBridge(@hero)
    gyro = new GyroBridge(@hero)

    @onRenderEnd = =>
      gyro.updateTargetDirectionFromGyro()
      @hero.applyDirections()


      # @hero.setLocation(2*(CAAT.rotationRate.gamma)+100, 100)
      # if @hero.moveLeft
      #   @hero.setLocation(@hero.x-1, @hero.y)

class Player extends CAAT.Actor
  constructor: ->
    super
    @initializeShape()
    @initializeDisplacement()

  initializeShape: ->
    @setSize(20,20)
    @setFillStyle('rgb(255,0,0)')

  initializeDisplacement: ->
    @directionFromKeys = {x:0, y:0}
    @directionFromGyro = {x:0, y:0}
    @velocity          = {x:0, y:0}
    @maxDistance = 5
    @friction = 0.3

  applyDamping: (v) ->
    adjusted = Math.max(Math.min(v,@maxDistance), - @maxDistance)
    adjusted = adjusted - @friction if adjusted > 0
    adjusted = adjusted + @friction if adjusted < 0
    adjusted = 0 if Math.abs(adjusted) < 0.3
    adjusted
      
    
  applyDirections: ->
    @velocity.x = @applyDamping(@velocity.x+@directionFromKeys.x+@directionFromGyro.x)
    @velocity.y = @applyDamping(@velocity.y+@directionFromKeys.y+@directionFromGyro.y)
    @setLocation( @x + @velocity.x, @y + @velocity.y )

class GyroBridge
  constructor: (@target) ->
    @sensivity = 10

  updateTargetDirectionFromGyro: () ->
    currentGamma = CAAT.rotationRate.gamma
    if Math.abs(currentGamma) > @sensivity
      if currentGamma > 0
        @target.directionFromGyro.x =  1
      else
        @target.directionFromGyro.x = -1
    else
      @target.directionFromGyro.x = 0



class KeyboardBridge
  constructor: (target) ->
    CAAT.registerKeyListener (key,action) =>
      target.directionFromKeys.x = -1 if @left(key) && @keyDown(action)
      target.directionFromKeys.x =  0 if @left(key) && @keyUp(action)

      target.directionFromKeys.x =  1 if @right(key) && @keyDown(action)
      target.directionFromKeys.x =  0 if @right(key) && @keyUp(action)

      target.directionFromKeys.y =  1 if @down(key) && @keyDown(action)
      target.directionFromKeys.y =  0 if @down(key) && @keyUp(action)

      target.directionFromKeys.y = -1 if @up(key) && @keyDown(action)
      target.directionFromKeys.y =  0 if @up(key) && @keyUp(action)

  left:  (k) -> k == 65 || k == 37
  right: (k) -> k == 68 || k == 39
  up:    (k) -> k == 87 || k == 38
  down:  (k) -> k == 83 || k == 40

  keyDown: (a) -> a == 'down'
  keyUp:   (a) -> a == 'up'

(exports ? this).Scene = Scene
