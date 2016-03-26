package entities {

import flash.ui.Keyboard;
import flash.utils.Dictionary;

import nape.geom.Vec2;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Circle;

import nape_stuff.Test;

import starling.events.Event;

import starling.events.KeyboardEvent;

import starling.textures.Texture;


public class Char extends Entity {

    private var _pressedKeys:Dictionary;
    private static var _speed:int = 150;
    private var _speedVec:Vec2;

    public function Char(entityName:String) {

        super(entityName);
        _view.pivotX = _view.pivotY = _view.width >> 1;
        createBody();

        _speedVec = new Vec2(0, 0);
        _pressedKeys = new Dictionary();
        _view.addEventListener(Event.ADDED_TO_STAGE, onAdded);

    }

    private function onAdded(e:Event):void {

        _view.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
        _view.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);

    }

    public function createBody():void {

        var pos:Vec2 = new Vec2(350, 150);
        _body = new Body(BodyType.DYNAMIC, pos);
        _body.shapes.add(new Circle(_view.width / 2));
        _body.debugDraw = true;

        _body.userData.graphics = _view;

    }


    override public function update():void {

        _speedVec.x = _speedVec.y = 0;
        _body.velocity = _speedVec;

        if(_pressedKeys[Keyboard.W]){
            _speedVec.y = -_speed;
            _body.velocity = _speedVec;
        }

        if(_pressedKeys[Keyboard.A]){
            _speedVec.x = -_speed;
            _body.velocity = _speedVec;
        }

        if(_pressedKeys[Keyboard.S]){
            _speedVec.y = _speed;
            _body.velocity = _speedVec;
        }

        if(_pressedKeys[Keyboard.D]) {
            _speedVec.x = _speed;
            _body.velocity = _speedVec;
        }
    }

    private function onKeyPressed(e:KeyboardEvent):void{
        _pressedKeys[e.keyCode] = true;
    }

    private function onKeyReleased(e:KeyboardEvent):void{
        _pressedKeys[e.keyCode] = false;
    }


}





















}
