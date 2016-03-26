package {

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.textures.RenderTexture;
import starling.textures.Texture;

public class DestructibleTerrain {

    private var _walls:Texture;
    private var _breakTexture:RenderTexture;

    public function DestructibleTerrain() {

    }

    public function init(walls:Texture):void{

        _breakTexture = new RenderTexture(walls.width, walls.height, true);
        _walls = walls;
        //TODO remove!!!
        var quad:Quad = new Quad(1, 1);
        _breakTexture.draw(quad);
    }

    public function addBreakage(element:DisplayObject):void{

        _breakTexture.draw(element);

    }

    public function getWallsTexture():Texture{
        return _walls;
    }

    public function getBreakageTexture():RenderTexture{
        return _breakTexture;
    }
}
}
