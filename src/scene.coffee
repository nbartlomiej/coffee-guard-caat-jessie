class Scene extends CAAT.Scene
  constructor: (@configuration) ->
    super

    @hero = new Player(this)
    @hero.setLocation(150,230)
    @addChild(@hero)

    new KeyboardBridge(@hero)
    gyro = new GyroBridge(@hero) if @configuration.os != 'Mac'

    @onRenderEnd = =>
      gyro?.updateTargetDirectionFromGyro()
      @hero.applyDirections()

class Player extends CAAT.Actor
  constructor: (@scene)->
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
    @maxSpeed = 10
    @friction = 0.3

  applyDamping: (v) ->
    adjusted = Math.max(Math.min(v,@maxSpeed), - @maxSpeed)
    adjusted = adjusted - @friction if adjusted > 0
    adjusted = adjusted + @friction if adjusted < 0
    adjusted = 0 if Math.abs(adjusted) < @friction
    adjusted
      
  keepInGameX: (x, velocity) ->
    width = @scene.configuration.width
    if (x + velocity.x > width) || (x + velocity.x < 0)
      velocity.x = 0.8 * (- velocity.x)
    Math.min(Math.max(x + velocity.x, 1), width-1)
    
  keepInGameY: (y, velocity) ->
    height = @scene.configuration.height
    if (y + velocity.y > height) || (y + velocity.y < 0)
      velocity.y = 0.7 * (- velocity.y)
    Math.min(Math.max(y + velocity.y, 1), height-1)

  applyDirections: ->
    @velocity.x = @applyDamping(@velocity.x+@directionFromKeys.x+@directionFromGyro.x)
    @velocity.y = @applyDamping(@velocity.y+@directionFromKeys.y+@directionFromGyro.y)
    @setLocation( @keepInGameX(@x , @velocity), @keepInGameY(@y , @velocity) )

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
    currentBeta = CAAT.rotationRate.beta - 60
    if Math.abs(currentBeta) > @sensivity
      if currentBeta > 0
        @target.directionFromGyro.y =  1
      else
        @target.directionFromGyro.y = -1
    else
      @target.directionFromGyro.y = 0



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
