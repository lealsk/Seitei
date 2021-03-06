package {

/**
 *
 * Sample: Destructible Terrain
 * Author: Luca Deltodesco
 *
 * Yet another sample featuring MarchingSquares,
 * this time used to implement destructible terrain with
 * use of a Bitmap for controlling removal from terrain.
 *
 * Terrain is chunked so that only necessary regions are
 * recomputed enabling higher performance.
 *
 */

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.geom.Point;

import nape.geom.AABB;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;
import nape.shape.Polygon;
import nape.space.Space;

import nape_stuff.Template;

// Template class is used so that this sample may
// be as concise as possible in showing Nape features without
// any of the boilerplate that makes up the sample interfaces.

import flash.display.BitmapData;
import flash.display.BitmapDataChannel;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.geom.Matrix;
import nape_stuff.Terrain;

[SWF(width="1024", height="600", frameRate="60", backgroundColor="#1d1d1d")]
public class NapeDestructibleTerrain extends Template {

    public function NapeDestructibleTerrain():void {

        super({
            gravity: Vec2.get(0, 700),
            staticClick: explosion,
            generator: createObject
        });

    }

    [Embed(source="assets/terrain.png")]
    private var TerrainClass:Class;

    private var terrain:Terrain;
    private var bomb:Sprite;

    override protected function init():void {

        var w:uint = stage.stageWidth;
        var h:uint = stage.stageHeight;

        createBorder();

        // Initialise terrain bitmap.
        var bit:BitmapData = new BitmapData(w, h, true, 0);
        bit.perlinNoise(200, 200, 2, 0x3ed, false, true, BitmapDataChannel.ALPHA, false);

        var terrainClass:Bitmap = new TerrainClass();
        var bit:BitmapData = terrainClass.bitmapData;
        bit.threshold(bit, bit.rect, new Point(), "==", 0xffffffff, 0x0000000, 0xffffffff);

        // Create initial terrain state, invalidating the whole screen.
        terrain = new Terrain(bit, 30, 5);
        terrain.invalidate(new AABB(0, 0, w, h), space);

        // Create bomb sprite for destruction
        bomb = new Sprite();
        bomb.graphics.beginFill(0xffffff, 1);
        bomb.graphics.drawCircle(0, 0, 20);
    }

    //Bypass this to determine how should the terrain be destroyed.
    private function explosion(pos:Vec2):void {
        // Erase bomb graphic out of terrain.
        terrain.bitmap.draw(bomb, new Matrix(1, 0, 0, 1, pos.x, pos.y), null, BlendMode.ERASE);

        // Invalidate region of terrain effected.
        var region:AABB = AABB.fromRect(bomb.getBounds(bomb));
        region.x += pos.x;
        region.y += pos.y;
        terrain.invalidate(region, space);

    }

    public function createObject(pos:Vec2, dO:DisplayObject = null):void {

        trace("once");
        var body:Body = new Body(BodyType.DYNAMIC, pos);


        if (Math.random() < 0.333) {
            body.shapes.add(new Circle(10 + Math.random()*20));
        }
        else {
            body.shapes.add(new Polygon(Polygon.regular(
                    /*radiusX*/ 10 + Math.random()*20,
                    /*radiusY*/ 10 + Math.random()*20,
                    /*numVerts*/ int(Math.random()*3 + 3)
            )));
        }
        body.space = space;

        //if(dO){
            var sprite:Sprite = new Sprite();
            sprite.graphics.beginFill(0xffffff, 1);
            sprite.graphics.drawCircle(0, 0, 10);
            body.userData.graphics = sprite;
            addChild(sprite);
        //}


    }

    public function showOrHide():void {

        debug.display.visible = !debug.display.visible;

    }

















}
}

