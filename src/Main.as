package {

import flash.desktop.NativeApplication;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.EventDispatcher;
import starling.events.KeyboardEvent;
import flash.ui.Keyboard;

import starling.events.Event;

public class Main extends Sprite {
    private var pressedKeys:Array = new Array(300);
    private var objects:Array = [];
    private var char:Object = null;
    private var core:Object = null;
    private var physicsDatas:Array = new Array();
    private var physicsDispatcher:EventDispatcher = new EventDispatcher();

    private var fog:Fog;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    }

    private function createElement():Object{
        return {view:{sprite:null, shadow:null}, physicsData:null, castsShadow:false, hitPoints:100};
    }

    private function onAddedToStage(e:Event):void{
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);

        var map:Object = createElement();
        map.view.sprite = new Quad(700, 500, 0xbb8855);
        addChild(map.view.sprite);

        map.physicsData = new PhysicsData();
        map.physicsData.owner = map;
        map.physicsData.width = 700;
        map.physicsData.height = 500;
        map.physicsData.container = true;
        physicsDatas.push(map.physicsData);
        objects.push(map);


        var crate:Object = createElement();
        crate.view.sprite = new Quad(50, 50, 0xffaa88);
        addChild(crate.view.sprite);

        crate.castsShadow = true;
        crate.physicsData = new PhysicsData();
        crate.physicsData.owner = crate;
        crate.physicsData.width = 50;
        crate.physicsData.height = 50;
        crate.physicsData.x = 100;
        crate.physicsData.y = 100;
        physicsDatas.push(crate.physicsData);
        objects.push(crate);


        var crate2:Object = createElement();
        crate2.view.sprite = new Quad(50, 50, 0xffaa88);
        addChild(crate2.view.sprite);

        crate2.castsShadow = true;
        crate2.physicsData = new PhysicsData();
        crate2.physicsData.owner = crate2;
        crate2.physicsData.width = 50;
        crate2.physicsData.height = 50;
        crate2.physicsData.x = 200;
        crate2.physicsData.y = 120;
        physicsDatas.push(crate2.physicsData);
        objects.push(crate2);


        char = createElement();
        char.view.sprite = new Quad(30, 30, 0x77ff11);
        addChild(char.view.sprite);

        char.physicsData = new PhysicsData();
        char.physicsData.owner = char;
        char.physicsData.width = 30;
        char.physicsData.height = 30;
        char.physicsData.x = 200;
        char.physicsData.y = 200;
        char.physicsData.checkCollisions = true;
        physicsDatas.push(char.physicsData);
        objects.push(char);


        core = createElement();
        core.view.sprite = new Quad(20, 20, 0x3388ff);
        addChild(core.view.sprite);

        core.castsShadow = true;
        core.physicsData = new PhysicsData();
        core.physicsData.owner = core;
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
        physicsDispatcher.addEventListener("collide", onCollide);
    }

    private function onEnterFrame(e:Event):void{

        updatePhysics(physicsDatas);
        fog.draw(char.physicsData.x+char.physicsData.width/2, char.physicsData.y+char.physicsData.height/2);

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
        if(pressedKeys[Keyboard.SPACE]){
            pressedKeys[Keyboard.SPACE] = false;

            var bullet:Object = createElement();
            bullet.view.sprite = new Quad(8, 8, 0xffaa88);
            addChild(bullet.view.sprite);

            bullet.physicsData = new PhysicsData();
            bullet.physicsData.owner = bullet;
            bullet.physicsData.width = 6;
            bullet.physicsData.height = 6;
            var dst:Number = 30;
            var px:Number = char.physicsData.x + char.physicsData.width / 2;
            var py:Number = char.physicsData.y + char.physicsData.height / 2;
            bullet.physicsData.x = px + Math.cos(char.physicsData.direction) * dst;
            bullet.physicsData.y = py + Math.sin(char.physicsData.direction) * dst;
            bullet.physicsData.z = 10;
            var spd:Number = 6;
            bullet.physicsData.velX = Math.cos(char.physicsData.direction) * spd;
            bullet.physicsData.velY = Math.sin(char.physicsData.direction) * spd;

            bullet.physicsData.checkCollisions = true;
            physicsDatas.push(bullet.physicsData);
            objects.push(bullet);
        }

        for each(var object:Object in objects){
            object.view.sprite.x = object.physicsData.x;
            object.view.sprite.y = object.physicsData.y;
        }
        x = -char.view.sprite.x+stage.stageWidth/2;
        y = -char.view.sprite.y+stage.stageHeight/2;

        if(char.physicsData.colliding == core.physicsData){
            NativeApplication.nativeApplication.exit();
        }
    }

    private function removeElement(element:Object):void{
        physicsDatas.splice(physicsDatas.indexOf(element.physicsData, 0), 1);
        if(element.castsShadow){
            fog.removeElement(element);
        }
        if(element.view.sprite.parent){
            element.view.sprite.parent.removeChild(element.view.sprite);
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
        pressedKeys[e.keyCode] = true;
    }

    private function onKeyReleased(e:KeyboardEvent):void{
        pressedKeys[e.keyCode] = false;
    }

    private function checkCollisions(data:PhysicsData, datas:Array):void{
        for each(var data2:PhysicsData in datas) {
            if(data2 != data) {
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
                        physicsDispatcher.dispatchEventWith("collide", false, data);
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
                        physicsDispatcher.dispatchEventWith("collide", false, data);
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
