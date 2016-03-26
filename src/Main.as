package {

import entities.Char;

import flash.filesystem.File;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import level.Camera;
import level.Level;

import nape.geom.Vec2;
import nape.phys.Body;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.deferredShading.lights.SpotLight;
import starling.utils.AssetManager;

public class Main extends Sprite {

    private var _pressedKeys:Dictionary;

    private var _char:Char;
    private var _controlledLight:SpotLight;
    private var _mouseX:int;
    private var _mouseY:int;
    private var _destructibleTerrain:DestructibleTerrain;
    private var _level:Level;
    private var _camera:Camera;
    private var _napeDestructibleTerrain:NapeDestructibleTerrain;
    private static var _assets:AssetManager;

    //camera moves the main container, where the action happens, UI, HUD and other components of the game go in a different container.
    private var _mainContainer:Sprite;

    public function Main() {

        _assets = new AssetManager();
        loadAssets(init);
        _napeDestructibleTerrain = new NapeDestructibleTerrain();
        Starling.current.nativeOverlay.addChild(_napeDestructibleTerrain);

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

        _pressedKeys = new Dictionary();
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

        _char = new Char("hero");
        _level.setChar(_char);


        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
        stage.addEventListener(TouchEvent.TOUCH, onTouch);

    }


    private function onKeyPressed(e:KeyboardEvent):void{

        _pressedKeys[e.keyCode] = true;

    }

    private function onKeyReleased(e:KeyboardEvent):void{

        _pressedKeys[e.keyCode] = false;

        if(e.keyCode == Keyboard.F){
            _napeDestructibleTerrain.showOrHide();
        }

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

        //if moving
        _char.update(_pressedKeys);

        _controlledLight.x = _char.getView().x + _char.getView().width/2;
        _controlledLight.y = _char.getView().y + _char.getView().height/2;

        _camera.update(_char.getView().x, _char.getView().y, _mouseX, _mouseY);
        _controlledLight.rotation = Math.atan2(_mouseY - (_controlledLight.y + _mainContainer.y), _mouseX - (_controlledLight.x + _mainContainer.x)) - Math.PI * 0.4;

        _napeDestructibleTerrain.getSpace().liveBodies.foreach(updateGraphics);

    }

    private function updateGraphics(body:Body):void {

        var graphic:Quad = body.userData.graphics;
        graphic.x = body.position.x;
        graphic.y = body.position.y;
        graphic.rotation = body.rotation;
        trace(graphic.x, graphic.y);

    }

    private function addBreakage(xPos:Number, yPos:Number):void{

        var breakage:Image = new Image(_assets.getTexture("break"));

        breakage.x = xPos - breakage.width/2 - _mainContainer.x;
        breakage.y = yPos - breakage.height/2 - _mainContainer.y;

        _destructibleTerrain.addBreakage(breakage);

        var quad:Quad = new Quad(30, 30);
        quad.pivotX = quad.width / 2;
        quad.pivotY = quad.height / 2;


        _mainContainer.addChild(quad);
        var pos:Vec2 = new Vec2(xPos, yPos);

        _napeDestructibleTerrain.createObject(pos, quad);


    }

    public static function getAssetManager():AssetManager {

        return _assets;

    }
























}
}
