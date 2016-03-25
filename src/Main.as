package {

import entities.Char;

import flash.filesystem.File;
import flash.ui.Keyboard;

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

    private var _pressedKeys:Array = new Array(300);
    private var _objects:Array = [];
    private var _char:Char;
    private var _controlledLight:SpotLight;
    private var _container:DeferredShadingContainer;
    private var _mouseX:int;
    private var _mouseY:int;
    private var _destructibleTerrain:DestructibleTerrain;
    private var _level:Level;

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

        _level = new Level();

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

        //TODO remove this from here
        if(hover){

            var light:SpotLight = _controlledLight as SpotLight;
            light.rotation = Math.atan2(hover.globalY-(light.y + y), hover.globalX - (light.x + x)) - Math.PI * 0.4;

        }

        if(began){

            addBreakage(touch.globalX, touch.globalY);

        }

    }

    private function onEnterFrame(e:Event):void{

        //if moving
        if(_pressedKeys[Keyboard.W] || _pressedKeys[Keyboard.A || _pressedKeys[Keyboard.S] || _pressedKeys[Keyboard.D]] ){

            _char.move(_pressedKeys);

        }


        for each(var object:Object in _objects){
            object.view.sprite.x = object.physicsData.x;
            object.view.sprite.y = object.physicsData.y;
        }

        var seeDistance:Number = stage.stageWidth / 8;
        x =  seeDistance - (_mouseX / stage.stageWidth) * seeDistance * 2 + stage.stageWidth / 2 - _char.view.sprite.x;
        y =  seeDistance - (_mouseY / stage.stageHeight) * seeDistance * 2 + stage.stageHeight / 2 - _char.view.sprite.y;

        _destructibleTerrain.setCamX(-x);
        _destructibleTerrain.setCamY(-y);

        var l:Light = _controlledLight as Light;
        l.x = _char.view.sprite.x + _char.physicsData.width/2;
        l.y = _char.view.sprite.y + _char.physicsData.height/2;
    }

    private function addBreakage(x:Number, y:Number):void{

        var breakage:Image = new Image(_assets.getTexture("break"));
        breakage.x = x - breakage.width/2 + _destructibleTerrain.getCamX();
        breakage.y = y - breakage.height/2 + _destructibleTerrain.getCamY();
        _destructibleTerrain.addBreakage(breakage);

    }


























}
}
