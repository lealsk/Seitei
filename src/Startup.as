package
{
import flash.display.Sprite;
import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.display3D.Context3DProfile;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.extensions.deferredShading.display.QuadBatchPlus;

[SWF(width="1024", height="600", frameRate="60", backgroundColor="#888888")]
public class Startup extends Sprite
{
    private var _starling:Starling;
    private var	stage3D:Stage3D;

    public function Startup()
    {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void
    {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

        stage3D = stage.stage3Ds[0];

        var viewport:Rectangle = new Rectangle(0, 0, 1024, 600);

        _starling = new Starling(Main, stage, viewport, stage3D, Context3DRenderMode.AUTO, Context3DProfile.STANDARD, QuadBatchPlus);
        _starling.stage.stageWidth  = stage.stageWidth;
        _starling.stage.stageHeight = stage.stageHeight;
        _starling.enableErrorChecking = false;//true;
        _starling.showStats = true;
        _starling.start();
    }
}
}