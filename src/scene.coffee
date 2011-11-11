class Scene extends CAAT.Scene
  constructor: (@configuration) ->
    super

    @score = document.getElementById('score')
    @score.textContent = "0"

    @topScore = document.getElementById('top')

    @player = new Player(this)
    @player.setLocation(150,330)
    @addChild(@player)

    @addEnemy()

    new KeyboardBridge(@player)
    accelerometer = new AccelerometerBridge(@player) if @configuration.os != 'Mac'

    @onRenderEnd = =>
      accelerometer?.updateTargetDirectionFromAccelerometer()
      @player.act()

  # Tests whether two objects collide with themselves.
  collides: (a, b) ->
    (a.x>b.x-a.width && a.x<b.x+b.width) && (a.y>b.y-a.height && a.y<b.y+b.height)

  getScore: -> parseInt(@score.textContent)
  incrementScore: -> @score.textContent = ""+(@getScore()+1)

  getTopScore: -> parseInt(@topScore.textContent) || 0
  setTopScore: (value) -> @topScore.textContent = ""+value

  addEnemy: ->
    score = @getScore()
    if score > 11 then @addChild(new PathEnemy(this, 1))
    else if score > 10 then @addChild(new CustomSpeedEnemy(this, 1))
    else if score > 9 then @addChild(new PathEnemy(this, 0.8))
    else if score > 8 then @addChild(new LinearPathEnemy(this, 1.1))
    else if score > 7 then @addChild(new LinearPathEnemy(this, 0.8))
    else if score > 6 then @addChild(new LinearPathEnemy(this, 0.6))
    else if score > 4 then @addChild(new CustomSpeedEnemy(this, 1))
    else if score > 2 then @addChild(new CustomSpeedEnemy(this, 0.8))
    else if score > 1 then @addChild(new CustomSpeedEnemy(this, 0.6))
    else @addChild(new CustomSpeedEnemy(this, 0.5))
    @setTopScore(score) if score > @getTopScore() && score > 0

  resetGame: ->
    @score.textContent = "0"
    @addEnemy()

class Controllable extends CAAT.Actor
  constructor: (@scene) ->
    super
    @initializeDisplacement()

  initializeDisplacement: ->
    @directionFromKeys = {x:0, y:0}
    @directionFromAccelerometer = {x:0, y:0}
    @velocity          = {x:0, y:0}
    @maxSpeed = 5
    @friction = 0.15

  applyDamping: (v) ->
    adjusted = Math.max(Math.min(v,@maxSpeed), - @maxSpeed)
    adjusted = adjusted - @friction if adjusted > 0
    adjusted = adjusted + @friction if adjusted < 0
    adjusted = 0 if Math.abs(adjusted) < @friction
    adjusted
      
  keepInGameX: (x, velocity) ->
    width = @scene.configuration.width - @width
    if (x + velocity.x > width) || (x + velocity.x < 0)
      velocity.x = 0.8 * (- velocity.x)
    Math.min(Math.max(x + velocity.x, 1), width-1)
    
  keepInGameY: (y, velocity) ->
    height = @scene.configuration.height - @height
    if (y + velocity.y > height) || (y + velocity.y < 0)
      velocity.y = 0.7 * (- velocity.y)
    Math.min(Math.max(y + velocity.y, 1), height-1)

  applyDirections: ->
    @velocity.x = @applyDamping(
      @velocity.x+@directionFromKeys.x+@directionFromAccelerometer.x
    )
    @velocity.y = @applyDamping(
      @velocity.y+@directionFromKeys.y+@directionFromAccelerometer.y
    )
    @setLocation( @keepInGameX(@x , @velocity), @keepInGameY(@y , @velocity) )

  act: -> @applyDirections()

class Player extends Controllable
  constructor: (@scene) ->
    super @scene
    @initializeShape()

  initializeShape: ->
    @setSize(30,30)
    @setFillStyle('rgb(0,0,0)')

  act: ->
    super()
    @scene.childrenList.forEach( (element) =>
      if (element != this) && (@scene.collides(this, element))
        element.caught()
        @scene.incrementScore()
        @scene.addEnemy()
        @addBehavior(
          new CAAT.ScaleBehavior()
            .setValues( 1, 1.1, 1, 1.1, @width, @height )
            .setFrameTime(@scene.time, 800 )
            .setInterpolator(new CAAT.Interpolator().createElasticOutInterpolator(2.5, .4) )
          )
    )

class AccelerometerBridge
  constructor: (@target) ->
    @sensivity = 0

  updateTargetDirectionFromAccelerometer: () ->
    currentGamma = CAAT.rotationRate.gamma
    if Math.abs(currentGamma) > @sensivity
      @target.directionFromAccelerometer.x = currentGamma / 20
      # if currentGamma > 0
      #   @target.directionFromAccelerometer.x =  1
      # else
      #   @target.directionFromAccelerometer.x = -1
    else
      @target.directionFromAccelerometer.x = 0
    currentBeta = CAAT.rotationRate.beta 
    if Math.abs(currentBeta) > @sensivity
      @target.directionFromAccelerometer.y = currentBeta / 10
      # if currentBeta > 0
      #   @target.directionFromAccelerometer.y =  1
      # else
      #   @target.directionFromAccelerometer.y = -1
    else
      @target.directionFromAccelerometer.y = 0

class KeyboardBridge
  constructor: (target) ->
    CAAT.registerKeyListener (key,action) =>
      if @keyDown(action)
        target.directionFromKeys.x = -1 if @left(key)
        target.directionFromKeys.x =  1 if @right(key)
        target.directionFromKeys.y =  1 if @down(key)
        target.directionFromKeys.y = -1 if @up(key)
      else if @keyUp(action)
        # Zeroing the vector unless the user is pressing the key for the
        # opposite direction.
        target.directionFromKeys.x = 0 if @left(key) && target.directionFromKeys.x!=1
        target.directionFromKeys.x = 0 if @right(key)&& target.directionFromKeys.x!=-1
        target.directionFromKeys.y = 0 if @up(key)   && target.directionFromKeys.y!=1
        target.directionFromKeys.y = 0 if @down(key) && target.directionFromKeys.y!=-1

  left:  (k) -> k == 65 || k == 37
  right: (k) -> k == 68 || k == 39
  up:    (k) -> k == 87 || k == 38
  down:  (k) -> k == 83 || k == 40

  keyDown: (a) -> a == 'down'
  keyUp:   (a) -> a == 'up'

class PlainEnemy extends CAAT.Actor
  constructor: (@scene, start=0) ->
    super
    @initializeShape()
    @act(start)

  random: (v) -> Math.round(Math.random()*v)

  initializeShape: ->
    @setSize(30,30)
    @setFillStyle('rgb('+(55+@random(150))+','+(55+@random(150))+','+(55+@random(150))+')')

  createPath: ->
    scene_width  = @scene.configuration.width
    scene_height = @scene.configuration.height
    column = @random(scene_width-@width)
    [start_x,start_y] = [column, -@height]
    # "column+1" is a hack. When actors follow straight path the canvas
    # renderer shows shaking.
    [end_x,end_y]     = [column+1, scene_height + @height]
    new CAAT.Path()
      .beginPath(start_x, start_y)
      .addCubicTo(start_x, start_y, end_x, end_y, end_x, end_y)
      .endPath()

  speed: -> 1

  flightTime: -> (1/@speed()) * 1000 * 2

  act: ()->
    @addBehavior(
      new CAAT.ScaleBehavior()
        .setValues( 1, 1.1, 1, 1.1, @width, @height )
        .setFrameTime(@scene.time, 1600 )
        .setInterpolator(new CAAT.Interpolator().createElasticOutInterpolator(2.5, .4) )
    )
    @addBehavior(
      new CAAT.PathBehavior()
        .setPath(@createPath())
        .setFrameTime(@scene.time, @flightTime() )
        .setAutoRotate(true)
        .addListener({ behaviorExpired: (behavior, time, actor) =>
          @scene.resetGame()
        })
    )

  caught: ->
    @setLocation( -@width, -@height)
    @setOutOfFrameTime()

class CustomSpeedEnemy extends PlainEnemy
  constructor: (@scene, @desiredSpeed) ->
    super(@scene)
  
  speed: -> @desiredSpeed

class LinearPathEnemy extends CustomSpeedEnemy
  constructor: (@scene, @desiredSpeed) ->
    super(@scene, @desiredSpeed)

  createPath: ->
    scene_width  = @scene.configuration.width
    scene_height = @scene.configuration.height
    column = @random(scene_width-@width)
    [start_x,start_y] = [column, -@height]
    [end_x,end_y] = [Math.min(scene_width-@width, Math.max(column+@random(100)-50, 0)), scene_height + @height]
    new CAAT.Path()
      .beginPath(start_x, start_y)
      .addCubicTo(start_x, start_y, end_x, end_y, end_x, end_y)
      .endPath()

class PathEnemy extends CustomSpeedEnemy
  constructor: (@scene, @desiredSpeed) ->
    super(@scene, @desiredSpeed)

  createPath: ->
    space_width  = @scene.configuration.width - @width
    space_height = @scene.configuration.height + @height
    new CAAT.Path()
      .beginPath(@random(space_width), 0 - @height)
      .addCubicTo(
        @random(space_width), @random(space_height),
        @random(space_width), @random(space_height),
        @random(space_width), space_height)
      .endPath()

(exports ? this).Scene = Scene
