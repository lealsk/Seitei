/**
 * Created by leandro on 2/20/2016.
 */
package {
import flash.geom.Matrix;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.textures.RenderTexture;
import starling.textures.Texture;

public class DestructibleTerrain {

    private var _walls:Texture;
    private var _breakages:Vector.<DisplayObject>;
    private var _breakTexture:RenderTexture;

    public function DestructibleTerrain() {

    }

    private function drawToRenderTexture(object:DisplayObject, renderTexture:RenderTexture):void{
        var mat:Matrix = new Matrix();
        mat.scale(object.scaleX, object.scaleY);
        mat.translate(object.x, object.y);
        renderTexture.draw(object, mat);
    }

    public function init(walls:Texture):void{
        _breakTexture = new RenderTexture(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, true);
        _walls = walls;
        _breakages = new <DisplayObject>[];
    }

    public function addBreakage(element:DisplayObject):void{
        _breakages.push(element);
        drawToRenderTexture(element, _breakTexture);
    }

    public function getWallsTexture():Texture{
        return _walls;
    }

    public function getBreakageTexture():RenderTexture{
        return _breakTexture;
    }
}
}
