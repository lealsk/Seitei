package nape_stuff {

import flash.filesystem.File;

import nape.geom.Vec2;
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
    private var _assets:AssetManager;
    private var _space:Space;

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

        _debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0x1d1d1d, true);
        _debug.display.alpha = 0.5;
        _debug.drawConstraints = true;
        Starling.current.nativeOverlay.addChild(_debug.display);

        var bg:Quad = new Quad(stage.stageWidth, stage.stageHeight, Color.GRAY);
        addChild(bg);

        addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        addEventListener(TouchEvent.TOUCH, onTouch);
        var vec2:Vec2 = new Vec2(0, 500);
        _space = new Space(vec2);
        createBorder();


    }

    private function onKeyUp(e:KeyboardEvent):void {

        _debug.display.visible = !_debug.display.visible;

    }


    private function onEnterFrame(e:Event):void {

        _space.step(1/60);
        _debug.clear();
        _debug.draw(_space);
        _debug.flush();

        _space.liveBodies.foreach(updateGraphics);

    }

    private function updateGraphics(body:Body):void {

        var dO:DisplayObject = body.userData.graphics;
        dO.x = body.position.x;
        dO.y = body.position.y;
        dO.rotation = body.rotation;

    }

    private function createObject(pos:Vec2):void {

        var image:Image = new Image(_assets.getTexture("nape_test"));

        var body:Body = new Body(BodyType.DYNAMIC, pos);
        var size:int = 10 + Math.random() * 20;
        body.shapes.add(new Circle(size));
        body.space = _space;
        body.debugDraw = true;

        image.pivotX = image.width / 2;
        image.pivotY = image.height / 2;
        image.width = size * 2;
        image.height = size * 2;


        body.userData.graphics = image;

        addChild(image);
        image.x = pos.x;
        image.y = pos.y;

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
            createObject(pos);
        }




    }



























}
}
