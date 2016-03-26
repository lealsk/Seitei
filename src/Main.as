package {

import flash.filesystem.File;

import level.Camera;
import level.Level;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.deferredShading.lights.SpotLight;
import starling.utils.AssetManager;

public class Main extends Sprite {

    private var _controlledLight:SpotLight;
    private var _mouseX:int;
    private var _mouseY:int;
    private var _destructibleTerrain:DestructibleTerrain;
    private var _level:Level;
    private var _camera:Camera;
    private static var _assets:AssetManager;

    //camera moves the main container, where the action happens, UI, HUD and other components of the game go in a different container.
    private var _mainContainer:Sprite;

    public function Main() {

        _assets = new AssetManager();
        loadAssets(init);

    }

    private function loadAssets(onComplete:Function):void
    {
        var appDir:File = File.applicationDirectory;
        _assets = new AssetManager();

        _assets.enqueue(
                appDir.resolvePath("assets/")
        );

        _assets.loadQueue(function(ratio:Number):void
        {
            if (ratio == 1) onComplete();
        });
    }

    /////////////////////////////////////////////////////////

    private function init():void {

        _mainContainer = new Sprite();
        _destructibleTerrain = new DestructibleTerrain();
        _destructibleTerrain.init(_assets.getTexture("terrain"));
        _level = new Level(_assets, _destructibleTerrain);
        _mainContainer.addChild(_level);

        //lights
        _controlledLight = new SpotLight(0xFFFFFFFF, .2, 800,0);
        _controlledLight.castsShadows = true;
        _controlledLight.angle = Math.PI * 0.8;
        _level.getDFC().addChild(_controlledLight);

        addChild(_mainContainer);

        _camera = new Camera(_mainContainer);


        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(TouchEvent.TOUCH, onTouch);


    }


    private function onTouch(e:TouchEvent):void{

        var began:Touch = e.getTouch(stage, TouchPhase.BEGAN);
        var hover:Touch = e.getTouch(stage, TouchPhase.HOVER);
        var touch:Touch = e.getTouch(this);

        if(began){

            addBreakage(began.globalX, began.globalY);

        }

        if(touch){

            _mouseX = touch.globalX;
            _mouseY = touch.globalY;

        }
    }

    private function onEnterFrame(e:Event):void{

        _level.update();

        var charX:int = _level.getChar().getView().x;
        var charY:int = _level.getChar().getView().y;

        _controlledLight.x = charX; //+ _level.getChar().getView().width/2;
        _controlledLight.y = charY;//+ _level.getChar().getView().height/2;

        //_camera.update(charX, charY, _mouseX, _mouseY);
        _controlledLight.rotation = Math.atan2(_mouseY - (_controlledLight.y + _mainContainer.y), _mouseX - (_controlledLight.x + _mainContainer.x)) - Math.PI * 0.4;

    }

    private function addBreakage(xPos:Number, yPos:Number):void{

        var breakage:Image = new Image(_assets.getTexture("break"));

        breakage.x = xPos - breakage.width/2 - _mainContainer.x;
        breakage.y = yPos - breakage.height/2 - _mainContainer.y;

        _destructibleTerrain.addBreakage(breakage);
        _level.addBreakage(xPos, yPos);

        //var pos:Vec2 = new Vec2(xPos, yPos);

    }











    public static function getAssetManager():AssetManager {

        return _assets;

    }























}
}
