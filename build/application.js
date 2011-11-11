var Application, Configuration, Scene;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
if (typeof exports !== "undefined" && exports !== null) {
  Scene = require('./../src/scene.coffee').Scene;
}
Configuration = (function() {
  function Configuration(width, height, os) {
    this.width = width;
    this.height = height;
    this.os = os;
  }
  return Configuration;
})();
Application = (function() {
  function Application(document) {
    this.width = 320;
    this.height = 480;
    this.director = this.embedApplication(document);
    this.imagesUrls = [];
    this.configuration = new Configuration(this.width, this.height, this.director.getOSName());
    this.scenes = [new Scene(this.configuration)];
  }
  Application.prototype.createScenes = function(director) {
    return director.addScene(this.scenes.pop());
  };
  Application.prototype.getCanvasContainer = function(document) {
    var canvasContainer;
    return canvasContainer = document.getElementById('application');
  };
  Application.prototype.embedApplication = function(document) {
    var canvasContainer, director;
    canvasContainer = this.getCanvasContainer(document);
    try {
      director = new CAAT.Director().initialize(this.width, this.height, void 0);
      canvasContainer.appendChild(director.canvas);
    } catch (error) {
      director = new CAAT.Director().initialize(this.width, this.height, canvasContainer);
    }
    return director;
  };
  Application.prototype.run = function(document) {
    return new CAAT.ImagePreloader().loadImages(this.imagesUrls, __bind(function(counter, images) {
      if (counter === images.length) {
        this.director.emptyScenes();
        this.director.setImagesCache(images);
        this.createScenes(this.director);
        return CAAT.loop(60);
      }
    }, this));
  };
  return Application;
})();
if (typeof window !== "undefined" && window !== null) {
  window.addEventListener('load', function() {
    var application;
    application = new Application(document);
    return application.run();
  });
}
(typeof exports !== "undefined" && exports !== null ? exports : this).Application = Application;