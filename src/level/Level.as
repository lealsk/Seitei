package level {
import entities.Char;
import entities.Entity;

import starling.display.Quad;
import starling.display.Sprite;
import starling.extensions.deferredShading.display.DeferredShadingContainer;
import starling.extensions.deferredShading.lights.AmbientLight;
import starling.utils.AssetManager;

public class Level extends Sprite {

    private var _DFC:DeferredShadingContainer;
    private var _assets:AssetManager;
    private var _destructibleTerrain:DestructibleTerrain;
        
    public function Level(assets:AssetManager, destructibleTerrain:DestructibleTerrain) {

        _assets = assets;
        _destructibleTerrain = destructibleTerrain;
        
        _DFC = new DeferredShadingContainer();
        addChild(_DFC);

        var bg:Quad = new Quad(destructibleTerrain.getWallsTexture().width, destructibleTerrain.getWallsTexture().height, 0xbb8855);
        _DFC.addChild(bg);


        var enemy1:Entity = new Entity("enemy1");

        _DFC.addChild(enemy1.getView());
        _DFC.addOccluder(enemy1.getView());

        /*var hiddenEnemey:Entity = new Entity("enemy1");
        _DFC.addHidden(hiddenEnemey.getView(), );*/

        _DFC.setDestructibleTerrain(destructibleTerrain);

        var ambient:AmbientLight = new AmbientLight(0x000000);
        _DFC.addChild(ambient);
        
    }
    
    public function getDFC():DeferredShadingContainer {
        
        return _DFC;
        
    }

    public function setChar(char:Char):void {

        _DFC.addChild(char.getView());

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
}
