package level {

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Cammera extends EventDispatcher{

    private static const SEE_DISTANCE_FACTOR:int = 8;

    private var _displayObject:DisplayObject;
    private var _seeDistance:int;
    private var _stageWidth:int;
    private var _stageHeight:int;

    public function Cammera(displayObject:DisplayObject) {

        _displayObject = displayObject;
        _seeDistance = displayObject.width / SEE_DISTANCE_FACTOR;
        _stageWidth = _displayObject.stage.stageWidth;
        _stageHeight = _displayObject.stage.stageHeight;

    }

    public function update(touch:Touch):void {



        _displayObject.x =  _seeDistance - (touch.globalX / _stageWidth) * _seeDistance * 2 + _stageWidth / 2; //- _char.view.sprite.x;
        _displayObject.y =  _seeDistance - (touch.globalY / _stageHeight) * _seeDistance * 2 + _stageHeight / 2;// - _char.view.sprite.y;





    }




}
}
