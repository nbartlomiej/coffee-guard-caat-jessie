(function() {
  var Application;
  Application = (function() {
    function Application() {}
    Application.prototype.createScenes = function(director) {
      var scene;
      scene = director.createScene();
      return scene.addChild(new CAAT.ShapeActor().setShape(CAAT.ShapeActor.prototype.SHAPE_CIRCLE).setLocation(325, 225).setSize(50, 50).setFillStyle('rgb(0,0,0)'));
    };
    return Application;
  })();
  if (typeof window !== "undefined" && window !== null) {
    window.addEventListener('load', function() {
      var application;
      application = new Application;
      return CAAT.modules.initialization.init(700, 500, void 0, [], application.createScenes);
    });
  }
  (typeof exports !== "undefined" && exports !== null ? exports : this).Application = Application;
}).call(this);
