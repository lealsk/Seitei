package {

import flash.desktop.NativeApplication;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

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
import starling.extensions.deferredShading.lights.PointLight;
import starling.extensions.deferredShading.lights.SpotLight;
import starling.textures.Texture;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class Main extends Sprite {
    private var pressedKeys:Array = new Array(300);
    private var objects:Array = [];
    private var char:Object = null;
    private var core:Object = null;
    private var physicsDatas:Array = new Array();
    private var physicsDispatcher:EventDispatcher = new EventDispatcher();
    private var controlledLight:SpotLight;
    private var container:DeferredShadingContainer;

    //TODO Create assets class
    [Embed (source="assets/face_diffuse.png")]
    public static const CHAR_DIFF:Class;
    [Embed (source="assets/test_sprites.png")]
    public static const TEST_SPRITES:Class;
    private var testSpritesAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new TEST_SPRITES(), false));

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

    }

    private function createElement():Object{
        return {view:{sprite:null, shadow:null}, physicsData:null, castsShadow:false, hidden:false, hitPoints:100};
    }

    private function onAddedToStage(e:Event):void{
        //TODO Move to assets class
        testSpritesAtlas.addRegion('enemy1', new Rectangle(637,5,128,245));

        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
        stage.addEventListener(TouchEvent.TOUCH, onTouch);

        container = new DeferredShadingContainer();
        addChild(container);
        var texture:Texture = Texture.fromEmbeddedAsset(CHAR_DIFF);

        var map:Object = createElement();
        map.view.sprite = new Quad(700, 500, 0xbb8855);
        container.addChild(map.view.sprite);

        map.physicsData = new PhysicsData();
        map.physicsData.owner = map;
        map.physicsData.width = 700;
        map.physicsData.height = 500;
        map.physicsData.container = true;
        physicsDatas.push(map.physicsData);
        objects.push(map);

        var crate:Object = createElement();
        crate.castsShadow = true;
        crate.physicsData = new PhysicsData();
        crate.physicsData.owner = crate;
        crate.physicsData.width = 200;
        crate.physicsData.height = 50;
        crate.physicsData.x = 100;
        crate.physicsData.y = 100;
        physicsDatas.push(crate.physicsData);
        objects.push(crate);

        var img:Image = new Image(texture);
        img.width = crate.physicsData.width;
        img.height = crate.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        crate.view.sprite = spr;
        container.addChild(crate.view.sprite);
        container.addOccluder(crate.view.sprite);


        var enemy:Object = createElement();
        var scale:Number = .25;
        enemy.hidden = true;
        enemy.physicsData = new PhysicsData();
        enemy.physicsData.owner = enemy;
        enemy.physicsData.width = testSpritesAtlas.getRegion('enemy1').width*scale;
        enemy.physicsData.height = testSpritesAtlas.getRegion('enemy1').height*scale;
        enemy.physicsData.x = 50;
        enemy.physicsData.y = 150;
        physicsDatas.push(enemy.physicsData);
        objects.push(enemy);

        var img:Image = new Image(testSpritesAtlas.getTexture('enemy1'));
        img.width = enemy.physicsData.width;
        img.height = enemy.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        enemy.view.sprite = spr;
        container.addHidden(enemy.view.sprite, container);


        var crate2:Object = createElement();

        crate2.castsShadow = true;
        crate2.physicsData = new PhysicsData();
        crate2.physicsData.owner = crate2;
        crate2.physicsData.width = 200;
        crate2.physicsData.height = 50;
        crate2.physicsData.x = 400;
        crate2.physicsData.y = 120;
        physicsDatas.push(crate2.physicsData);
        objects.push(crate2);

        var img:Image = new Image(texture);
        img.width = crate2.physicsData.width;
        img.height = crate2.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        crate2.view.sprite = spr;
        container.addChild(crate2.view.sprite);
        container.addOccluder(crate2.view.sprite);


        char = createElement();
        char.view.sprite = new Quad(30, 30, 0x77ff11);
        container.addChild(char.view.sprite);

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

        core.castsShadow = true;
        core.physicsData = new PhysicsData();
        core.physicsData.owner = core;
        core.physicsData.width = 80;
        core.physicsData.height = 20;
        core.physicsData.x = 400;
        core.physicsData.y = 320;
        physicsDatas.push(core.physicsData);
        objects.push(core);

        var img:Image = new Image(texture);
        img.width = core.physicsData.width;
        img.height = core.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        core.view.sprite = spr;
        container.addChild(core.view.sprite);
        container.addOccluder(core.view.sprite);

        controlledLight = new SpotLight(0xFFFFFFFF, .2, 800,0);
        controlledLight.castsShadows = true;
        controlledLight.angle = Math.PI*.8;
        container.addChild(controlledLight);

        var ambient:AmbientLight = new AmbientLight(0x000000);
        container.addChild(ambient);

        physicsDispatcher.addEventListener("collide", onCollide);
    }

    private function onEnterFrame(e:Event):void{

        updatePhysics(physicsDatas);

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

        for each(var object:Object in objects){
            object.view.sprite.x = object.physicsData.x;
            object.view.sprite.y = object.physicsData.y;
        }
        x = -char.view.sprite.x+stage.stageWidth/2;
        y = -char.view.sprite.y+stage.stageHeight/2;
        var l:Light = controlledLight as Light;
        l.x = char.view.sprite.x + char.physicsData.width/2;
        l.y = char.view.sprite.y + char.physicsData.height/2;

        if(char.physicsData.colliding == core.physicsData){
            NativeApplication.nativeApplication.exit();
        }
    }

    private function removeElement(element:Object):void{
        physicsDatas.splice(physicsDatas.indexOf(element.physicsData, 0), 1);
        if(element.hidden){
            container.removeHidden(element.view.sprite);
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
        pressedKeys[e.keyCode] = true;
    }

    private function onKeyReleased(e:KeyboardEvent):void{
        pressedKeys[e.keyCode] = false;
    }

    private function onTouch(e:TouchEvent):void{
        var touch:Touch = e.getTouch(this);
        if(!touch) {
            return;
        }
        if(touch.phase == TouchPhase.BEGAN){

            var bullet:Object = createElement();
            bullet.view.sprite = new Quad(8, 8, 0xffaa88);
            container.addChild(bullet.view.sprite);

            bullet.physicsData = new PhysicsData();
            bullet.physicsData.owner = bullet;
            bullet.physicsData.width = 6;
            bullet.physicsData.height = 6;
            var dst:Number = 30;
            var px:Number = char.physicsData.x + char.physicsData.width / 2;
            var py:Number = char.physicsData.y + char.physicsData.height / 2;


            var rotation:Number = Math.atan2(touch.globalY-(controlledLight.y+y), touch.globalX-(controlledLight.x+x));

            bullet.physicsData.x = px + Math.cos(rotation) * dst;
            bullet.physicsData.y = py + Math.sin(rotation) * dst;
            bullet.physicsData.z = 10;
            var spd:Number = 6;
            bullet.physicsData.velX = Math.cos(rotation) * spd;
            bullet.physicsData.velY = Math.sin(rotation) * spd;

            bullet.physicsData.checkCollisions = true;
            physicsDatas.push(bullet.physicsData);
            objects.push(bullet);

        }
        var l:SpotLight = controlledLight as SpotLight;
        l.rotation = Math.atan2(touch.globalY-(l.y+y), touch.globalX-(l.x+x))-Math.PI*.4;
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
