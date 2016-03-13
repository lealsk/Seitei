package {

import flash.desktop.NativeApplication;
import flash.filesystem.File;
import flash.display.StageDisplayState;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.Capabilities;
import flash.ui.Keyboard;

import starling.core.Starling;

import starling.display.Image;
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
import starling.extensions.deferredShading.lights.AmbientLight;
import starling.extensions.deferredShading.lights.Light;
import starling.extensions.deferredShading.lights.SpotLight;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.AssetManager;

public class Main extends Sprite {

    private var _pressedKeys:Array = new Array(300);
    private var _objects:Array = [];
    private var _char:Object = null;
    private var _core:Object = null;
    private var _physicsDatas:Array = new Array();
    private var _physicsDispatcher:EventDispatcher = new EventDispatcher();
    private var _controlledLight:SpotLight;
    private var _container:DeferredShadingContainer;
    private var _mouseX:int;
    private var _mouseY:int;
    private var destructibleTerrain:DestructibleTerrain;

    private var _assets:AssetManager;

    //camera moves the main container, where the action happens, UI, HUD and other components of the game go in a different container.
    private var _mainContainer:Sprite;
    [Embed (source="assets/break.png")]
    public static const BREAK:Class;
    private var breakTexture:Texture = Texture.fromBitmap(new BREAK, false);
    [Embed (source="assets/test_terrain.png")]
    public static const TEST_TERRAIN:Class;
    private var testTerrainTexture:Texture = Texture.fromBitmap(new TEST_TERRAIN, false);

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

        buildLevel();

    }

    private function createElement():Object{

        return {view:{sprite:null, shadow:null}, physicsData:null, castsShadow:false, hidden:false, hitPoints:100};

    }

    private function buildLevel():void{

        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
        stage.addEventListener(TouchEvent.TOUCH, onTouch);

        _container = new DeferredShadingContainer();
        _mainContainer = new Sprite();
        addChild(_mainContainer);
        _mainContainer.addChild(_container);
        var texture:Texture = _assets.getTexture("enemy1");

        var map:Object = createElement();
        map.view.sprite = new Quad(700, 500, 0xbb8855);
        _container.addChild(map.view.sprite);

        map.physicsData = new PhysicsData();
        map.physicsData.owner = map;
        map.physicsData.width = 700;
        map.physicsData.height = 500;
        map.physicsData.container = true;
        _physicsDatas.push(map.physicsData);
        _objects.push(map);

        var crate:Object = createElement();
        crate.castsShadow = true;
        crate.physicsData = new PhysicsData();
        crate.physicsData.owner = crate;
        crate.physicsData.width = 200;
        crate.physicsData.height = 50;
        crate.physicsData.x = 100;
        crate.physicsData.y = 100;
        _physicsDatas.push(crate.physicsData);
        _objects.push(crate);

        var img:Image = new Image(texture);
        img.width = crate.physicsData.width;
        img.height = crate.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        crate.view.sprite = spr;
        _container.addChild(crate.view.sprite);
        _container.addOccluder(crate.view.sprite);


        var enemy:Object = createElement();
        var scale:Number = .25;
        enemy.hidden = true;
        enemy.physicsData = new PhysicsData();
        enemy.physicsData.owner = enemy;
        enemy.physicsData.width = _assets.getTexture("enemy1").width * scale;
        enemy.physicsData.height = _assets.getTexture("enemy1").height * scale;
        enemy.physicsData.x = 50;
        enemy.physicsData.y = 150;
        _physicsDatas.push(enemy.physicsData);
        _objects.push(enemy);

        var img:Image = new Image(_assets.getTexture("enemy1"));
        img.width = enemy.physicsData.width;
        img.height = enemy.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        enemy.view.sprite = spr;
        _container.addHidden(enemy.view.sprite, this);

        var crate2:Object = createElement();

        crate2.castsShadow = true;
        crate2.physicsData = new PhysicsData();
        crate2.physicsData.owner = crate2;
        crate2.physicsData.width = 200;
        crate2.physicsData.height = 50;
        crate2.physicsData.x = 400;
        crate2.physicsData.y = 120;
        _physicsDatas.push(crate2.physicsData);
        _objects.push(crate2);

        var img:Image = new Image(texture);
        img.width = crate2.physicsData.width;
        img.height = crate2.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        crate2.view.sprite = spr;
        _container.addChild(crate2.view.sprite);
        _container.addOccluder(crate2.view.sprite);


        _char = createElement();
        _char.view.sprite = new Quad(30, 30, 0x77ff11);
        _container.addChild(_char.view.sprite);

        _char.physicsData = new PhysicsData();
        _char.physicsData.owner = _char;
        _char.physicsData.width = 30;
        _char.physicsData.height = 30;
        _char.physicsData.x = 200;
        _char.physicsData.y = 200;
        _char.physicsData.checkCollisions = true;
        _physicsDatas.push(_char.physicsData);
        _objects.push(_char);


        _core = createElement();

        _core.castsShadow = true;
        _core.physicsData = new PhysicsData();
        _core.physicsData.owner = _core;
        _core.physicsData.width = 80;
        _core.physicsData.height = 20;
        _core.physicsData.x = 400;
        _core.physicsData.y = 320;
        _physicsDatas.push(_core.physicsData);
        _objects.push(_core);

        var img:Image = new Image(texture);
        img.width = _core.physicsData.width;
        img.height = _core.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        _core.view.sprite = spr;
        _container.addChild(_core.view.sprite);
        _container.addOccluder(_core.view.sprite);

        _controlledLight = new SpotLight(0xFFFFFFFF, .2, 800,0);
        _controlledLight.castsShadows = true;
        _controlledLight.angle = Math.PI*.8;
        _container.addChild(_controlledLight);
        destructibleTerrain = new DestructibleTerrain();
        destructibleTerrain.init(testTerrainTexture);
        _container.setDestructibleTerrain(destructibleTerrain);

        var ambient:AmbientLight = new AmbientLight(0x000000);
        _container.addChild(ambient);

        _physicsDispatcher.addEventListener("collide", onCollide);
    }

    private function onEnterFrame(e:Event):void{

        updatePhysics(_physicsDatas);

        //addBreakage(Math.random()*stage.stageWidth, Math.random()*stage.stageHeight);

        var spd:Number = 3;
        if(_pressedKeys[Keyboard.D]){
            _char.physicsData.velX = spd;
        }
        if(_pressedKeys[Keyboard.A]){
            _char.physicsData.velX = -spd;
        }
        if(_pressedKeys[Keyboard.W]){
            _char.physicsData.velY = -spd;
        }
        if(_pressedKeys[Keyboard.S]){
            _char.physicsData.velY = spd;
        }

        for each(var object:Object in _objects){
            object.view.sprite.x = object.physicsData.x;
            object.view.sprite.y = object.physicsData.y;
        }

        var seeDistance:Number = stage.stageWidth / 8;
        x =  seeDistance - (_mouseX / stage.stageWidth) * seeDistance * 2 + stage.stageWidth / 2 - _char.view.sprite.x;
        y =  seeDistance - (_mouseY / stage.stageHeight) * seeDistance * 2 + stage.stageHeight / 2 - _char.view.sprite.y;

        destructibleTerrain.setCamX(-x);
        destructibleTerrain.setCamY(-y);

        var l:Light = _controlledLight as Light;
        l.x = _char.view.sprite.x + _char.physicsData.width/2;
        l.y = _char.view.sprite.y + _char.physicsData.height/2;
    }

    private function removeElement(element:Object):void{
        _physicsDatas.splice(_physicsDatas.indexOf(element.physicsData, 0), 1);
        if(element.hidden){
            _container.removeHidden(element.view.sprite);
        } else {
            if (element.view.sprite.parent) {
                element.view.sprite.parent.removeChild(element.view.sprite);
            }
        }
    }

    private function onCollide(e:Event, data:Object):void{
        // TODO Add a property to indicate damage on collision
        if(data.z > 0) {
            var target:Object = data.owner.physicsData.colliding.owner;
            target.hitPoints -= 10;
            removeElement(data.owner);
            if(!target.physicsData.container) {
                if (target.hitPoints <= 0) {
                    removeElement(target);
                }
            }
        }
    }

    private function onKeyPressed(e:KeyboardEvent):void{
        _pressedKeys[e.keyCode] = true;
    }

    private function onKeyReleased(e:KeyboardEvent):void{
        _pressedKeys[e.keyCode] = false;
    }

    private function onTouch(e:TouchEvent):void{

        var touch:Touch = e.getTouch(this);
        var began:Touch = e.getTouch(this, TouchPhase.BEGAN);
        var hover:Touch = e.getTouch(this, TouchPhase.HOVER);

        if(touch){
            _mouseX = touch.globalX;
            _mouseY = touch.globalY;
        }

        if(began){

            var bullet:Object = createElement();
            bullet.view.sprite = new Quad(8, 8, 0xffaa88);
            _container.addChild(bullet.view.sprite);

            bullet.physicsData = new PhysicsData();
            bullet.physicsData.owner = bullet;
            bullet.physicsData.width = 6;
            bullet.physicsData.height = 6;
            var dst:Number = 30;
            var px:Number = _char.physicsData.x + _char.physicsData.width / 2;
            var py:Number = _char.physicsData.y + _char.physicsData.height / 2;


            var rotation:Number = Math.atan2(began.globalY-(_controlledLight.y+y), began.globalX-(_controlledLight.x+x));

            bullet.physicsData.x = px + Math.cos(rotation) * dst;
            bullet.physicsData.y = py + Math.sin(rotation) * dst;
            bullet.physicsData.z = 10;
            var spd:Number = 6;
            bullet.physicsData.velX = Math.cos(rotation) * spd;
            bullet.physicsData.velY = Math.sin(rotation) * spd;

            bullet.physicsData.checkCollisions = true;
            _physicsDatas.push(bullet.physicsData);
            _objects.push(bullet);

        }

        if(hover){


            var light:SpotLight = _controlledLight as SpotLight;
            light.rotation = Math.atan2(hover.globalY-(light.y + y), hover.globalX - (light.x + x)) - Math.PI * 0.4;


        }

        if(touch && touch.phase == TouchPhase.MOVED){
            //TODO Move code elsewhere
            addBreakage(touch.globalX, touch.globalY);
        }

    }

    private function addBreakage(x:Number, y:Number):void{
        var breakage:Image = new Image(breakTexture);
        breakage.x = x - breakage.width/2 + destructibleTerrain.getCamX();
        breakage.y = y - breakage.height/2 + destructibleTerrain.getCamY();
        destructibleTerrain.addBreakage(breakage);

    }

    private function checkCollisions(data:PhysicsData, datas:Array):void{
        for each(var data2:PhysicsData in datas) {
            if(data2 != data && data2.colliding != data) {
                data.colliding = null;
                if (data2.container) {
                    // Collision with walls
                    //
                    if (data.x + data.velX < data2.x || data.x + data.velX + data.width > data2.x + data2.width) {
                        data.colliding = data2;
                        data.velX = data.x + data.velX < data2.x ? data2.x - data.x : (data2.x + data2.width) - (data.x+data.width);

                    }
                    if (data.y + data.velY < data2.y || data.y + data.velY + data.height > data2.y + data2.height) {
                        data.colliding = data2;
                        data.velY = data.y + data.velY < data2.y ? data2.y - data.y : (data2.y + data2.height) - (data.y+data.height);
                    }
                    if (data.colliding) {
                        _physicsDispatcher.dispatchEventWith("collide", false, data);
                    }
                } else {
                    // Collision with objects
                    //
                    if(data.x + data.velX + data.width > data2.x && data.x  + data.velX < data2.x + data2.width && data.y + data.height > data2.y && data.y < data2.y + data2.height ){
                        data.colliding = data2;
                        //var vel:Number = data.x + data.width <= data2.x && data.x + data.width + data.velX > data2.x ? data2.x - (data.x + data.width) : (data2.x + data2.width) - data.x;
                        data2.velX = data.velX;
                        checkCollisions(data2, datas);
                        data.velX = data2.velX;
                    }
                    if(data.x + data.width > data2.x && data.x < data2.x + data2.width && data.y + data.velY + data.height > data2.y && data.y + data.velY < data2.y + data2.height ){
                        data.colliding = data2;
                        //var vel:Number = data.y + data.height <= data2.y && data.y + data.height + data.velY > data2.y ? data2.y - (data.y + data.height) : (data2.y + data2.height) - data.y;
                        data2.velY = data.velY;
                        checkCollisions(data2, datas);
                        data.velY = data2.velY;
                    }
                    if(data.colliding){
                        _physicsDispatcher.dispatchEventWith("collide", false, data);
                    }
                }
            }
        }
    }

    private function updatePhysics(datas:Array):void{

        for each(var data:PhysicsData in datas) {

            if (data.checkCollisions) {
                checkCollisions(data, datas);
            }
        }

        for each(var data:PhysicsData in datas){

            data.x += data.velX;
            data.y += data.velY;

            if(data.velX != 0 || data.velY != 0) {
                data.direction = Math.atan2(data.velY, data.velX);
            }
        }

        for each(var data:PhysicsData in datas){
            if(data.z <= 0) {
                data.velX = 0;
                data.velY = 0;
            }
        }
    }
}
}
