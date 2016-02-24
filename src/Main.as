package {

import flash.desktop.NativeApplication;
import flash.geom.Matrix;
import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;

import starling.events.Event;
import starling.textures.RenderTexture;

public class Main extends Sprite {
    private var pressedKeys:Array = new Array(300);
    private var char:Object = {view:null, physicsData:null};
    private var crate:Object = {view:null, physicsData:null};
    private var crate2:Object = {view:null, physicsData:null};
    private var core:Object = {view:null, physicsData:null};
    private var physicsDatas:Array = new Array();

    private var shadows:Array = [];
    private var shadowTexture:RenderTexture;
    private var shadowImage:Image;
    private var shadowObjects:Array = new Array();

    private function createShadows(element:Object):Object{
        var shadows:Array = new Array();
        var shadow:Polygon;

        shadow = new Polygon([{x:0,y:0}, {x:element.physicsData.width,y:0}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x;
        shadow.y = element.physicsData.y;
        shadows.push(shadow);

        shadow = new Polygon([{x:0,y:0}, {x:0,y:element.physicsData.height}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x + element.physicsData.width;
        shadow.y = element.physicsData.y;
        shadows.push(shadow);

        shadow = new Polygon([{x:0,y:0}, {x:element.physicsData.width,y:0}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x;
        shadow.y = element.physicsData.y + element.physicsData.height;
        shadows.push(shadow);

        shadow = new Polygon([{x:0,y:0}, {x:0,y:element.physicsData.height}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x;
        shadow.y = element.physicsData.y;
        shadows.push(shadow);

        return {element:element, shadows:shadows};
    }

    private function updateShadow(centerX:Number, centerY:Number, shadow:Object):void{
        var posX:Number = shadow.element.physicsData.x;
        var posY:Number = shadow.element.physicsData.y;
        shadow.shadows[0].vertexData.setPosition(2, posX+((posX + shadow.element.physicsData.width) - centerX)*100, posY+((posY + 0) - centerY)*100);
        shadow.shadows[0].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + 0) - centerY)*100);
        shadow.shadows[1].vertexData.setPosition(2, posX+((posX + 0) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[1].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + 0) - centerY)*100);
        shadow.shadows[2].vertexData.setPosition(2, posX+((posX + shadow.element.physicsData.width) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[2].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[3].vertexData.setPosition(2, posX+((posX + 0) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[3].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + 0) - centerY)*100);

        var matrix:Matrix = new Matrix();
        matrix.translate(shadow.shadows[0].x, shadow.shadows[0].y);
        shadowTexture.draw(shadow.shadows[0], matrix);
        matrix.translate(-shadow.shadows[0].x, -shadow.shadows[0].y);
        matrix.translate(shadow.shadows[1].x, shadow.shadows[1].y);
        shadowTexture.draw(shadow.shadows[1], matrix);
        matrix.translate(-shadow.shadows[1].x, -shadow.shadows[1].y);
        matrix.translate(shadow.shadows[2].x, shadow.shadows[2].y);
        shadowTexture.draw(shadow.shadows[2], matrix);
        matrix.translate(-shadow.shadows[2].x, -shadow.shadows[2].y);
        matrix.translate(shadow.shadows[3].x, shadow.shadows[3].y);
        shadowTexture.draw(shadow.shadows[3], matrix);
    }

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    }

    private function onAddedToStage(e:Event):void{
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);

        var map:Object = {view:null, physicsData:null};
        map.view = new Quad(700, 500, 0xbb8855);
        addChild(map.view);

        map.physicsData = new PhysicsData();
        map.physicsData.width = 700;
        map.physicsData.height = 500;
        map.physicsData.container = true;
        physicsDatas.push(map.physicsData);


        crate.view = new Quad(50, 50, 0xffaa88);
        addChild(crate.view);

        crate.physicsData = new PhysicsData();
        crate.physicsData.width = 50;
        crate.physicsData.height = 50;
        crate.physicsData.x = 100;
        crate.physicsData.y = 100;
        physicsDatas.push(crate.physicsData);


        shadowTexture = new RenderTexture(stage.stageWidth, stage.stageHeight);


        crate2.view = new Quad(50, 50, 0xffaa88);
        addChild(crate2.view);

        crate2.physicsData = new PhysicsData();
        crate2.physicsData.width = 50;
        crate2.physicsData.height = 50;
        crate2.physicsData.x = 200;
        crate2.physicsData.y = 120;
        physicsDatas.push(crate2.physicsData);


        char.view = new Quad(30, 30, 0x77ff11);
        addChild(char.view);

        char.physicsData = new PhysicsData();
        char.physicsData.width = 30;
        char.physicsData.height = 30;
        char.physicsData.x = 200;
        char.physicsData.y = 200;
        char.physicsData.checkCollisions = true;
        physicsDatas.push(char.physicsData);


        core.view = new Quad(20, 20, 0x3388ff);
        addChild(core.view);

        core.physicsData = new PhysicsData();
        core.physicsData.width = 20;
        core.physicsData.height = 20;
        core.physicsData.x = 400;
        core.physicsData.y = 320;
        physicsDatas.push(core.physicsData);

        shadows.push(createShadows(crate));
        shadows.push(createShadows(crate2));
        shadows.push(createShadows(core));

        shadowImage = new Image(shadowTexture);
        shadowImage.alpha = .1;
        addChild(shadowImage);

    }

    private function onEnterFrame(e:Event):void{

        shadowTexture.clear();
        for each(var shadow:Object in shadows) {
            updateShadow(char.physicsData.x, char.physicsData.y, shadow);
            updateShadow(char.physicsData.x, char.physicsData.y, shadow);
        }

        char.physicsData.velX = 0;
        char.physicsData.velY = 0;
        var spd:Number = 3;
        if(pressedKeys[Keyboard.D]){
            char.physicsData.velX = spd;
        }
        if(pressedKeys[Keyboard.A]){
            char.physicsData.velX = -spd;
        }
        if(pressedKeys[Keyboard.W]){
            char.physicsData.velY = -spd;
        }
        if(pressedKeys[Keyboard.S]){
            char.physicsData.velY = spd;
        }

        updatePhysics(physicsDatas);

        char.view.x = char.physicsData.x;
        char.view.y = char.physicsData.y;
        crate.view.x = crate.physicsData.x;
        crate.view.y = crate.physicsData.y;
        crate2.view.x = crate2.physicsData.x;
        crate2.view.y = crate2.physicsData.y;
        core.view.x = core.physicsData.x;
        core.view.y = core.physicsData.y;
        x = -char.view.x+stage.stageWidth/2;
        y = -char.view.y+stage.stageHeight/2;

        if(char.physicsData.colliding == core.physicsData){
            NativeApplication.nativeApplication.exit();
        }
    }

    private function onKeyPressed(e:KeyboardEvent):void{
        pressedKeys[e.keyCode] = true;
    }

    private function onKeyReleased(e:KeyboardEvent):void{
        pressedKeys[e.keyCode] = false;
    }

    private function updatePhysics(datas:Array):void{
        for each(var data:PhysicsData in datas){
            data.x += data.velX;
            data.y += data.velY;
        }
        for each(var data:PhysicsData in datas) {
            if (data.checkCollisions) {
                for each(var data2:PhysicsData in datas) {
                    if(data2 != data) {
                        data.colliding = null;
                        if (data2.container) {
                            if (data.x < data2.x || data.x + data.width > data2.x + data2.width) {
                                data.colliding = data2;
                                data.x -= data.velX;
                            }
                            if (data.y < data2.y || data.y + data.height > data2.y + data2.height) {
                                data.colliding = data2;
                                data.y -= data.velY;
                            }
                            if (data.colliding) {
                                break;
                            }
                        } else {

                            if(data.x + data.width > data2.x && data.x < data2.x + data2.width && data.y - data.velY + data.height > data2.y && data.y - data.velY < data2.y + data2.height ){
                                data.colliding = data2;
                                data.x -= data.velX;
                            }
                            if(data.x - data.velX + data.width > data2.x && data.x - data.velX < data2.x + data2.width && data.y + data.height > data2.y && data.y < data2.y + data2.height ){
                                data.colliding = data2;
                                data.y -= data.velY;
                            }
                            if (data.colliding) {
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
}
}
