package {

import flash.desktop.NativeApplication;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;

import starling.events.Event;

public class Main extends Sprite {
    private var pressedKeys:Array = new Array(300);
    private var objects:Array = [];
    private var char:Object = null;
    private var core:Object = null;
    private var physicsDatas:Array = new Array();

    private var fog:Fog;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    }

    private function createElement():Object{
        return {view:null, physicsData:null, castsShadow:false};
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
        objects.push(map);


        var crate:Object = createElement();
        crate.view = new Quad(50, 50, 0xffaa88);
        addChild(crate.view);

        crate.castsShadow = true;
        crate.physicsData = new PhysicsData();
        crate.physicsData.width = 50;
        crate.physicsData.height = 50;
        crate.physicsData.x = 100;
        crate.physicsData.y = 100;
        physicsDatas.push(crate.physicsData);
        objects.push(crate);


        var crate2:Object = createElement();
        crate2.view = new Quad(50, 50, 0xffaa88);
        addChild(crate2.view);

        crate2.castsShadow = true;
        crate2.physicsData = new PhysicsData();
        crate2.physicsData.width = 50;
        crate2.physicsData.height = 50;
        crate2.physicsData.x = 200;
        crate2.physicsData.y = 120;
        physicsDatas.push(crate2.physicsData);
        objects.push(crate2);


        char = createElement();
        char.view = new Quad(30, 30, 0x77ff11);
        addChild(char.view);

        char.physicsData = new PhysicsData();
        char.physicsData.width = 30;
        char.physicsData.height = 30;
        char.physicsData.x = 200;
        char.physicsData.y = 200;
        char.physicsData.checkCollisions = true;
        physicsDatas.push(char.physicsData);
        objects.push(char);


        core = createElement();
        core.view = new Quad(20, 20, 0x3388ff);
        addChild(core.view);

        core.castsShadow = true;
        core.physicsData = new PhysicsData();
        core.physicsData.width = 20;
        core.physicsData.height = 20;
        core.physicsData.x = 400;
        core.physicsData.y = 320;
        physicsDatas.push(core.physicsData);
        objects.push(core);

        fog = new Fog();
        addChild(fog.init(stage));
        for each(var object:Object in objects){
            if(object.castsShadow){
                fog.addElement(object);
            }
        }
    }

    private function onEnterFrame(e:Event):void{
        fog.draw(char.physicsData.x, char.physicsData.y);

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

        for each(var object:Object in objects){
            object.view.x = object.physicsData.x;
            object.view.y = object.physicsData.y;
        }
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
