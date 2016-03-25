package {

import entities.Char;

import flash.filesystem.File;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import level.Cammera;

import level.Level;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.deferredShading.display.DeferredShadingContainer;
import starling.extensions.deferredShading.lights.Light;
import starling.extensions.deferredShading.lights.SpotLight;
import starling.utils.AssetManager;

public class Main extends Sprite {

    private var _pressedKeys:Dictionary;

    private var _char:Char;
    private var _controlledLight:SpotLight;
    private var _container:DeferredShadingContainer;
    private var _mouseX:int;
    private var _mouseY:int;
    private var _destructibleTerrain:DestructibleTerrain;
    private var _level:Level;
    private var _cammera:Cammera;


    private var _assets:AssetManager;

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

        _pressedKeys = new Dictionary();
        _mainContainer = new Sprite();
        _level = new Level(_assets);
        _mainContainer.addChild(_level);
        addChild(_mainContainer);

        _cammera = new Cammera(_mainContainer);

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
        addEventListener(TouchEvent.TOUCH, onTouch);

    }


    private function onKeyPressed(e:KeyboardEvent):void{

        _pressedKeys[e.keyCode] = true;

    }

    private function onKeyReleased(e:KeyboardEvent):void{

        _pressedKeys[e.keyCode] = false;

    }

    private function onTouch(e:TouchEvent):void{

        var began:Touch = e.getTouch(this, TouchPhase.BEGAN);
        var hover:Touch = e.getTouch(this, TouchPhase.HOVER);

        if(touch){
            _mouseX = touch.globalX;
            _mouseY = touch.globalY;
        }

        if(began){

            addBreakage(touch.globalX, touch.globalY);

        }

        if(hover){

            _cammera.update(hover);
            _controlledLight.rotation = Math.atan2(hover.globalY - (_controlledLight.y + y), hover.globalX - (_controlledLight.x + x)) - Math.PI * 0.4;

        }

    }

    private function onEnterFrame(e:Event):void{

        //if moving
        _char.move(_pressedKeys);

        //TODO remove this dependency
        _destructibleTerrain.setCamX(-x);
        _destructibleTerrain.setCamX(-y);

        /*_controlledLight.x = _char.view.sprite.x + _char.physicsData.width/2;
        _controlledLight.y = _char.view.sprite.y + _char.physicsData.height/2;*/


    }

    private function addBreakage(xPos:Number, yPos:Number):void{

        var breakage:Image = new Image(_assets.getTexture("break"));
        breakage.x = xPos;
        breakage.y = yPos;
        _destructibleTerrain.addBreakage(breakage);

    }


























}
}
