package nape_stuff {

import entities.Char;
import entities.Entity;

import flash.filesystem.File;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;

import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Image;

import starling.display.Quad;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.AssetManager;
import starling.utils.Color;

public class Test extends Sprite {

    private var _debug:Debug;
    private static var _assets:AssetManager;
    private static var _space:Space;
    private var _pressedKeys:Dictionary;
    private var _char:Char;
    private var _entities:Vector.<Entity>;

    public function Test() {

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

        _entities = new <Entity>[];
        _pressedKeys = new Dictionary();
        _debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0x1d1d1d, true);
        _debug.display.alpha = 0.5;
        _debug.drawConstraints = true;
        Starling.current.nativeOverlay.addChild(_debug.display);

        var bg:Quad = new Quad(stage.stageWidth, stage.stageHeight, Color.GRAY);
        addChild(bg);

        addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        addEventListener(TouchEvent.TOUCH, onTouch);
        var vec2:Vec2 = new Vec2(0, 500);
        _space = new Space();
        createBorder();

        createChar();

    }

    private function onKeyDown(e:KeyboardEvent):void{
        _pressedKeys[e.keyCode] = true;
    }

    private function onKeyUp(e:KeyboardEvent):void{
        _pressedKeys[e.keyCode] = false;
    }

    private function onEnterFrame(e:Event):void {

        _space.step(1/60);
        _debug.clear();
        _debug.draw(_space);
        _debug.flush();

        for each(var entity:Entity in _entities){
            entity.update();
        }

        _space.bodies.foreach(updateGraphics);


    }

    private function updateGraphics(body:Body):void {

        var dO:DisplayObject = body.userData.graphics;
        dO.x = body.position.x;
        dO.y = body.position.y;
        dO.rotation = body.rotation;
        trace(body.velocity);

    }



    private function createRandomObject(pos:Vec2):void {

        var image:Image = new Image(_assets.getTexture("nape_test"));

        var size:int = 10 + Math.random() * 20;

        image.pivotX = image.width / 2;
        image.pivotY = image.height / 2;
        image.width = size * 2;
        image.height = size * 2;

        addChild(image);

        createBody(pos, image);

    }

    private function createChar():void {

        _char = new Char("hero");
        addChild(_char.getView());

        _entities.push(_char);

    }

    private function createBody(pos:Vec2, dO:DisplayObject):void {

        var body:Body = new Body(BodyType.DYNAMIC, pos);
        body.shapes.add(new Circle(dO.width / 2));
        body.space = _space;
        body.debugDraw = true;
        body.inertia = 5;
        body.userData.graphics = dO;

    }

    private function createBorder():void {

        var border:Body = new Body(BodyType.STATIC);
        border.shapes.add(new Polygon(Polygon.rect(0, 0, -2, stage.stageHeight)));
        border.shapes.add(new Polygon(Polygon.rect(0, 0, stage.stageWidth, -2)));
        border.shapes.add(new Polygon(Polygon.rect(stage.stageWidth, 0, 2, stage.stageHeight)));
        border.shapes.add(new Polygon(Polygon.rect(0, stage.stageHeight, stage.stageWidth, 2)));
        border.space = _space;
        border.debugDraw = true;

    }

    private function onTouch(e:TouchEvent):void {

        var began:Touch = e.getTouch(this, TouchPhase.BEGAN);

        if(began){
            var pos:Vec2 = Vec2.get(began.globalX, began.globalY);
            createRandomObject(pos);
        }
    }

    public static function getAssetManager():AssetManager {
        return _assets;
    }

    public static function getSpace():Space {
        return _space;
    }




























}
}
