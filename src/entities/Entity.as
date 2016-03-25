package entities {
import starling.display.Image;
import starling.textures.Texture;

public class Entity {

    protected var _view:Image;

    public function Entity(viewTexture:Texture) {

        _view = new Image(viewTexture);

    }






}
}
