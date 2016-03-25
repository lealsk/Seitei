package level {

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Camera extends EventDispatcher{

    private static const SEE_DISTANCE:int = 100;

    private var _stageWidth:int;
    private var _stageHeight:int;
    private var _displayObject:DisplayObject;

    public function Camera(displayObject:DisplayObject) {

        _displayObject = displayObject;
        _stageWidth = _displayObject.stage.stageWidth;
        _stageHeight = _displayObject.stage.stageHeight;

    }

    public function update(posX:int, posY:int, mouseX:int, mouseY:int):void {

        _displayObject.x =  int(SEE_DISTANCE - (mouseX / _stageWidth) * SEE_DISTANCE * 2 + _stageWidth / 2 - posX);
        _displayObject.y =  int(SEE_DISTANCE - (mouseY / _stageHeight) * SEE_DISTANCE * 2 + _stageHeight / 2 - posY);


    }







}
}
