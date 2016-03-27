package level {

import starling.display.DisplayObject;
import starling.events.EventDispatcher;

public class Camera extends EventDispatcher{

    private static const SEE_DISTANCE:int = 100;

    private var _stageWidth:int;
    private var _stageHeight:int;
    private var _displayObject:DisplayObject;
    private var _camPosX:int;
    private var _camPosY:int;

    public function Camera(displayObject:DisplayObject) {

        _displayObject = displayObject;
        _stageWidth = _displayObject.stage.stageWidth;
        _stageHeight = _displayObject.stage.stageHeight;

    }

    public function update(posX:int, posY:int, mouseX:int, mouseY:int):void {

        _displayObject.x = _camPosX = int(SEE_DISTANCE - (mouseX / _stageWidth) * SEE_DISTANCE * 2 + _stageWidth / 2 - posX);
        _displayObject.y = _camPosY = int(SEE_DISTANCE - (mouseY / _stageHeight) * SEE_DISTANCE * 2 + _stageHeight / 2 - posY);

    }

    public function getXCamPos():int {
        return _camPosX;
    }

    public function getYCamPos():int {
        return _camPosY;
    }



}
}
