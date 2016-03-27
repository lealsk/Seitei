package entities {
import nape.phys.Body;
import nape.space.Space;

import nape_stuff.Test;

import starling.display.Image;
import starling.events.EventDispatcher;

public class Entity extends EventDispatcher{

    protected var _view:Image;
    protected var _body:Body;

    public function Entity(entityName:String) {

        _view = new Image(Main.getAssetManager().getTexture(entityName));

    }

    public function getView():Image {

        return _view;

    }

    //override
    public function update():void {}

    public function setSpace(space:Space):void {
        _body.space = space;
    }



}
}
