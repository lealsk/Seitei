package level {
import entities.Char;
import entities.Entity;

import flash.display.Bitmap;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

import nape.geom.AABB;
import nape.geom.Vec2;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;

import nape_stuff.Terrain;

import starling.core.Starling;
import starling.display.DisplayObject;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.deferredShading.display.DeferredShadingContainer;
import starling.extensions.deferredShading.lights.AmbientLight;
import starling.utils.AssetManager;

public class Level extends starling.display.Sprite {

    [Embed(source="../assets/terrain.png")]
    private var TerrainClass:Class;

    private var _DFC:DeferredShadingContainer;
    private var _assets:AssetManager;
    private var _destructibleTerrain:DestructibleTerrain;
    private var _entities:Vector.<Entity>;
    private var _space:Space;
    private var _debug:Debug;
    private var _char:Char;
    private var _napeTerrain:Terrain;
    private var _breackage:flash.display.Sprite;

    public function Level(assets:AssetManager, destructibleTerrain:DestructibleTerrain) {

        _assets = assets;
        _destructibleTerrain = destructibleTerrain;
        
        _DFC = new DeferredShadingContainer();
        addChild(_DFC);

        var bg:Quad = new Quad(700, 500, 0xbb8855);
        _DFC.addChild(bg);

        _DFC.setDestructibleTerrain(destructibleTerrain);

        var ambient:AmbientLight = new AmbientLight(0x000000);
        _DFC.addChild(ambient);

        addEventListener(Event.ADDED_TO_STAGE, onAdded);

        //TODO change this!
        _breackage = new flash.display.Sprite();
        _breackage.graphics.beginFill(0xffffff, 1);
        _breackage.graphics.drawCircle(0, 0, 20);

    }

    private function onAdded(e:Event):void {

        setup();
        initNapeTerrain();

    }

    public function addBreakage(xPos:int, yPos:int):void {

        // Erase graphic out of terrain.
        _napeTerrain.bitmap.draw(_breackage, new Matrix(1, 0, 0, 1, xPos, yPos), null, BlendMode.ERASE);

        // Invalidate region of terrain effected.
        var region:AABB = AABB.fromRect(_breackage.getBounds(_breackage));
        region.x += xPos;
        region.y += yPos;
        _napeTerrain.invalidate(region, _space);

        _char.setSpace(_space);

    }


    private function initNapeTerrain():void {

        var w:uint = stage.stageWidth;
        var h:uint = stage.stageHeight;

        // Initialise terrain bitmap.
        var terrainClass:Bitmap = new TerrainClass();
        var bit:BitmapData = terrainClass.bitmapData;

        bit.threshold(bit, bit.rect, new Point(), "==", 0xffffffff, 0x0000000, 0xffffffff);

        // Create initial terrain state, invalidating the whole screen.
        _napeTerrain = new Terrain(bit, 30, 5);
        _napeTerrain.invalidate(new AABB(0, 0, w, h), _space);

        //for some reason the char has to be added after the creation of the terrain
        addChar();

    }

    private function addChar():void {

        _char = new Char("hero");
        _char.setSpace(_space);
        addChild(_char.getView());
        _entities.push(_char);

    }

    public function setup():void {

        _space = new Space();
        _entities = new <Entity>[];
        _debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0x1d1d1d, true);
        _debug.display.alpha = 1;
        _debug.drawConstraints = true;
        Starling.current.nativeOverlay.addChild(_debug.display);

        //createBorder();

    }

    public function getChar():Char {

        return _char;

    }

    public function update():void {

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

    }



    private function createBorder():void {

        /*var border:Body = new Body(BodyType.STATIC);
        border.shapes.add(new Polygon(Polygon.rect(0, 0, -2, stage.stageHeight)));
        border.shapes.add(new Polygon(Polygon.rect(0, 0, stage.stageWidth, -2)));
        border.shapes.add(new Polygon(Polygon.rect(stage.stageWidth, 0, 2, stage.stageHeight)));
        border.shapes.add(new Polygon(Polygon.rect(0, stage.stageHeight, stage.stageWidth, 2)));
        border.space = Main.getSpace();
        border.debugDraw = true;*/

    }

    public function getDFC():DeferredShadingContainer {
        
        return _DFC;
        
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
}
