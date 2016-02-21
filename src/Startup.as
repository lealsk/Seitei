package
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import starling.core.Starling;

[SWF(width="640", height="480", frameRate="60", backgroundColor="#222222")]
public class Startup extends Sprite
{
    private var starlingInstance:Starling;

    public function Startup()
    {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void
    {
        stage.scaleMode = StageScaleMode.SHOW_ALL;
        stage.align = StageAlign.TOP_LEFT;

        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        starlingInstance = new Starling(Main, stage);
        starlingInstance.start();
    }
}
}