var AccelerometerBridge, Controllable, CustomSpeedEnemy, KeyboardBridge, LinearPathEnemy, PathEnemy, PlainEnemy, Player, Scene;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
}, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Scene = (function() {
  __extends(Scene, CAAT.Scene);
  function Scene(configuration) {
    var accelerometer;
    this.configuration = configuration;
    Scene.__super__.constructor.apply(this, arguments);
    this.score = document.getElementById('score');
    this.score.textContent = "0";
    this.topScore = document.getElementById('top');
    this.player = new Player(this);
    this.player.setLocation(150, 330);
    this.addChild(this.player);
    this.addEnemy();
    new KeyboardBridge(this.player);
    if (this.configuration.os !== 'Mac') {
      accelerometer = new AccelerometerBridge(this.player);
    }
    this.onRenderEnd = __bind(function() {
      if (accelerometer != null) {
        accelerometer.updateTargetDirectionFromAccelerometer();
      }
      return this.player.act();
    }, this);
  }
  Scene.prototype.collides = function(a, b) {
    return (a.x > b.x - a.width && a.x < b.x + b.width) && (a.y > b.y - a.height && a.y < b.y + b.height);
  };
  Scene.prototype.getScore = function() {
    return parseInt(this.score.textContent);
  };
  Scene.prototype.incrementScore = function() {
    return this.score.textContent = "" + (this.getScore() + 1);
  };
  Scene.prototype.getTopScore = function() {
    return parseInt(this.topScore.textContent) || 0;
  };
  Scene.prototype.setTopScore = function(value) {
    return this.topScore.textContent = "" + value;
  };
  Scene.prototype.addEnemy = function() {
    var score;
    score = this.getScore();
    if (score > 11) {
      this.addChild(new PathEnemy(this, 1));
    } else if (score > 10) {
      this.addChild(new CustomSpeedEnemy(this, 1));
    } else if (score > 9) {
      this.addChild(new PathEnemy(this, 0.8));
    } else if (score > 8) {
      this.addChild(new LinearPathEnemy(this, 1.1));
    } else if (score > 7) {
      this.addChild(new LinearPathEnemy(this, 0.8));
    } else if (score > 6) {
      this.addChild(new LinearPathEnemy(this, 0.6));
    } else if (score > 4) {
      this.addChild(new CustomSpeedEnemy(this, 1));
    } else if (score > 2) {
      this.addChild(new CustomSpeedEnemy(this, 0.8));
    } else if (score > 1) {
      this.addChild(new CustomSpeedEnemy(this, 0.6));
    } else {
      this.addChild(new CustomSpeedEnemy(this, 0.5));
    }
    if (score > this.getTopScore() && score > 0) {
      return this.setTopScore(score);
    }
  };
  Scene.prototype.resetGame = function() {
    this.score.textContent = "0";
    return this.addEnemy();
  };
  return Scene;
})();
Controllable = (function() {
  __extends(Controllable, CAAT.Actor);
  function Controllable(scene) {
    this.scene = scene;
    Controllable.__super__.constructor.apply(this, arguments);
    this.initializeDisplacement();
  }
  Controllable.prototype.initializeDisplacement = function() {
    this.directionFromKeys = {
      x: 0,
      y: 0
    };
    this.directionFromAccelerometer = {
      x: 0,
      y: 0
    };
    this.velocity = {
      x: 0,
      y: 0
    };
    this.maxSpeed = 5;
    return this.friction = 0.15;
  };
  Controllable.prototype.applyDamping = function(v) {
    var adjusted;
    adjusted = Math.max(Math.min(v, this.maxSpeed), -this.maxSpeed);
    if (adjusted > 0) {
      adjusted = adjusted - this.friction;
    }
    if (adjusted < 0) {
      adjusted = adjusted + this.friction;
    }
    if (Math.abs(adjusted) < this.friction) {
      adjusted = 0;
    }
    return adjusted;
  };
  Controllable.prototype.keepInGameX = function(x, velocity) {
    var width;
    width = this.scene.configuration.width - this.width;
    if ((x + velocity.x > width) || (x + velocity.x < 0)) {
      velocity.x = 0.8 * (-velocity.x);
    }
    return Math.min(Math.max(x + velocity.x, 1), width - 1);
  };
  Controllable.prototype.keepInGameY = function(y, velocity) {
    var height;
    height = this.scene.configuration.height - this.height;
    if ((y + velocity.y > height) || (y + velocity.y < 0)) {
      velocity.y = 0.7 * (-velocity.y);
    }
    return Math.min(Math.max(y + velocity.y, 1), height - 1);
  };
  Controllable.prototype.applyDirections = function() {
    this.velocity.x = this.applyDamping(this.velocity.x + this.directionFromKeys.x + this.directionFromAccelerometer.x);
    this.velocity.y = this.applyDamping(this.velocity.y + this.directionFromKeys.y + this.directionFromAccelerometer.y);
    return this.setLocation(this.keepInGameX(this.x, this.velocity), this.keepInGameY(this.y, this.velocity));
  };
  Controllable.prototype.act = function() {
    return this.applyDirections();
  };
  return Controllable;
})();
Player = (function() {
  __extends(Player, Controllable);
  function Player(scene) {
    this.scene = scene;
    Player.__super__.constructor.call(this, this.scene);
    this.initializeShape();
  }
  Player.prototype.initializeShape = function() {
    this.setSize(30, 30);
    return this.setFillStyle('rgb(0,0,0)');
  };
  Player.prototype.act = function() {
    Player.__super__.act.call(this);
    return this.scene.childrenList.forEach(__bind(function(element) {
      if ((element !== this) && (this.scene.collides(this, element))) {
        element.caught();
        this.scene.incrementScore();
        this.scene.addEnemy();
        return this.addBehavior(new CAAT.ScaleBehavior().setValues(1, 1.1, 1, 1.1, this.width, this.height).setFrameTime(this.scene.time, 800).setInterpolator(new CAAT.Interpolator().createElasticOutInterpolator(2.5, .4)));
      }
    }, this));
  };
  return Player;
})();
AccelerometerBridge = (function() {
  function AccelerometerBridge(target) {
    this.target = target;
    this.sensivity = 0;
  }
  AccelerometerBridge.prototype.updateTargetDirectionFromAccelerometer = function() {
    var currentBeta, currentGamma;
    currentGamma = CAAT.rotationRate.gamma;
    if (Math.abs(currentGamma) > this.sensivity) {
      this.target.directionFromAccelerometer.x = currentGamma / 20;
    } else {
      this.target.directionFromAccelerometer.x = 0;
    }
    currentBeta = CAAT.rotationRate.beta;
    if (Math.abs(currentBeta) > this.sensivity) {
      return this.target.directionFromAccelerometer.y = currentBeta / 10;
    } else {
      return this.target.directionFromAccelerometer.y = 0;
    }
  };
  return AccelerometerBridge;
})();
KeyboardBridge = (function() {
  function KeyboardBridge(target) {
    CAAT.registerKeyListener(__bind(function(key, action) {
      if (this.keyDown(action)) {
        if (this.left(key)) {
          target.directionFromKeys.x = -1;
        }
        if (this.right(key)) {
          target.directionFromKeys.x = 1;
        }
        if (this.down(key)) {
          target.directionFromKeys.y = 1;
        }
        if (this.up(key)) {
          return target.directionFromKeys.y = -1;
        }
      } else if (this.keyUp(action)) {
        if (this.left(key) && target.directionFromKeys.x !== 1) {
          target.directionFromKeys.x = 0;
        }
        if (this.right(key) && target.directionFromKeys.x !== -1) {
          target.directionFromKeys.x = 0;
        }
        if (this.up(key) && target.directionFromKeys.y !== 1) {
          target.directionFromKeys.y = 0;
        }
        if (this.down(key) && target.directionFromKeys.y !== -1) {
          return target.directionFromKeys.y = 0;
        }
      }
    }, this));
  }
  KeyboardBridge.prototype.left = function(k) {
    return k === 65 || k === 37;
  };
  KeyboardBridge.prototype.right = function(k) {
    return k === 68 || k === 39;
  };
  KeyboardBridge.prototype.up = function(k) {
    return k === 87 || k === 38;
  };
  KeyboardBridge.prototype.down = function(k) {
    return k === 83 || k === 40;
  };
  KeyboardBridge.prototype.keyDown = function(a) {
    return a === 'down';
  };
  KeyboardBridge.prototype.keyUp = function(a) {
    return a === 'up';
  };
  return KeyboardBridge;
})();
PlainEnemy = (function() {
  __extends(PlainEnemy, CAAT.Actor);
  function PlainEnemy(scene, start) {
    this.scene = scene;
    if (start == null) {
      start = 0;
    }
    PlainEnemy.__super__.constructor.apply(this, arguments);
    this.initializeShape();
    this.act(start);
  }
  PlainEnemy.prototype.random = function(v) {
    return Math.round(Math.random() * v);
  };
  PlainEnemy.prototype.initializeShape = function() {
    this.setSize(30, 30);
    return this.setFillStyle('rgb(' + (55 + this.random(150)) + ',' + (55 + this.random(150)) + ',' + (55 + this.random(150)) + ')');
  };
  PlainEnemy.prototype.createPath = function() {
    var column, end_x, end_y, scene_height, scene_width, start_x, start_y, _ref, _ref2;
    scene_width = this.scene.configuration.width;
    scene_height = this.scene.configuration.height;
    column = this.random(scene_width - this.width);
    _ref = [column, -this.height], start_x = _ref[0], start_y = _ref[1];
    _ref2 = [column + 1, scene_height + this.height], end_x = _ref2[0], end_y = _ref2[1];
    return new CAAT.Path().beginPath(start_x, start_y).addCubicTo(start_x, start_y, end_x, end_y, end_x, end_y).endPath();
  };
  PlainEnemy.prototype.speed = function() {
    return 1;
  };
  PlainEnemy.prototype.flightTime = function() {
    return (1 / this.speed()) * 1000 * 2;
  };
  PlainEnemy.prototype.act = function() {
    this.addBehavior(new CAAT.ScaleBehavior().setValues(1, 1.1, 1, 1.1, this.width, this.height).setFrameTime(this.scene.time, 1600).setInterpolator(new CAAT.Interpolator().createElasticOutInterpolator(2.5, .4)));
    return this.addBehavior(new CAAT.PathBehavior().setPath(this.createPath()).setFrameTime(this.scene.time, this.flightTime()).setAutoRotate(true).addListener({
      behaviorExpired: __bind(function(behavior, time, actor) {
        return this.scene.resetGame();
      }, this)
    }));
  };
  PlainEnemy.prototype.caught = function() {
    this.setLocation(-this.width, -this.height);
    return this.setOutOfFrameTime();
  };
  return PlainEnemy;
})();
CustomSpeedEnemy = (function() {
  __extends(CustomSpeedEnemy, PlainEnemy);
  function CustomSpeedEnemy(scene, desiredSpeed) {
    this.scene = scene;
    this.desiredSpeed = desiredSpeed;
    CustomSpeedEnemy.__super__.constructor.call(this, this.scene);
  }
  CustomSpeedEnemy.prototype.speed = function() {
    return this.desiredSpeed;
  };
  return CustomSpeedEnemy;
})();
LinearPathEnemy = (function() {
  __extends(LinearPathEnemy, CustomSpeedEnemy);
  function LinearPathEnemy(scene, desiredSpeed) {
    this.scene = scene;
    this.desiredSpeed = desiredSpeed;
    LinearPathEnemy.__super__.constructor.call(this, this.scene, this.desiredSpeed);
  }
  LinearPathEnemy.prototype.createPath = function() {
    var column, end_x, end_y, scene_height, scene_width, start_x, start_y, _ref, _ref2;
    scene_width = this.scene.configuration.width;
    scene_height = this.scene.configuration.height;
    column = this.random(scene_width - this.width);
    _ref = [column, -this.height], start_x = _ref[0], start_y = _ref[1];
    _ref2 = [Math.min(scene_width - this.width, Math.max(column + this.random(100) - 50, 0)), scene_height + this.height], end_x = _ref2[0], end_y = _ref2[1];
    return new CAAT.Path().beginPath(start_x, start_y).addCubicTo(start_x, start_y, end_x, end_y, end_x, end_y).endPath();
  };
  return LinearPathEnemy;
})();
PathEnemy = (function() {
  __extends(PathEnemy, CustomSpeedEnemy);
  function PathEnemy(scene, desiredSpeed) {
    this.scene = scene;
    this.desiredSpeed = desiredSpeed;
    PathEnemy.__super__.constructor.call(this, this.scene, this.desiredSpeed);
  }
  PathEnemy.prototype.createPath = function() {
    var space_height, space_width;
    space_width = this.scene.configuration.width - this.width;
    space_height = this.scene.configuration.height + this.height;
    return new CAAT.Path().beginPath(this.random(space_width), 0 - this.height).addCubicTo(this.random(space_width), this.random(space_height), this.random(space_width), this.random(space_height), this.random(space_width), space_height).endPath();
  };
  return PathEnemy;
})();
(typeof exports !== "undefined" && exports !== null ? exports : this).Scene = Scene;