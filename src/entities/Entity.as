package entities {
import starling.display.Image;
import starling.textures.Texture;

public class Entity {

    protected var _view:Image;

    public function Entity(entityName:String) {

        _view = new Image(Main.getAssetManager().getTexture(entityName));

    }

    public function getView():Image {

        return _view;

    }





}
}
