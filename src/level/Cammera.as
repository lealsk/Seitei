package level {

import starling.display.DisplayObject;
import starling.events.EventDispatcher;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class Cammera extends EventDispatcher{

    private var _displayObject:DisplayObject;

    public function Cammera(displayObject:DisplayObject) {


        addEventListener(TouchEvent.TOUCH, onTouch);

    }

    private function onTouch(e:TouchEvent):void{

        var hover:Touch = e.getTouch(_displayObject, TouchPhase.HOVER);

        if(hover){




        }

    }


}
}
