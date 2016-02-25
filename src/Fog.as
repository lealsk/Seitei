/**
 * Created by leandro on 2/24/2016.
 */
package {
import flash.geom.Matrix;

import starling.display.Image;
import starling.display.Stage;
import starling.textures.RenderTexture;

public class Fog {

    private var shadows:Array = [];
    private var shadowTexture:RenderTexture;
    private var shadowImage:Image;

    public function Fog() {

    }

    public function init(stage:Stage):Image{

        shadowTexture = new RenderTexture(stage.stageWidth, stage.stageHeight);

        shadowImage = new Image(shadowTexture);
        shadowImage.alpha = .1;
        return shadowImage;
    }

    public function draw(centerX:Number, centerY:Number){

        shadowTexture.clear();
        for each(var shadow:Object in shadows) {
            updateShadow(centerX, centerY, shadow);
        }
    }

    public function addElement(element:Object):void{
        shadows.push(createShadows(element));
    }

    private function createShadows(element:Object):Object{
        var shadows:Array = new Array();
        var shadow:Polygon;

        shadow = new Polygon([{x:0,y:0}, {x:element.physicsData.width,y:0}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x;
        shadow.y = element.physicsData.y;
        shadows.push(shadow);

        shadow = new Polygon([{x:0,y:0}, {x:0,y:element.physicsData.height}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x + element.physicsData.width;
        shadow.y = element.physicsData.y;
        shadows.push(shadow);

        shadow = new Polygon([{x:0,y:0}, {x:element.physicsData.width,y:0}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x;
        shadow.y = element.physicsData.y + element.physicsData.height;
        shadows.push(shadow);

        shadow = new Polygon([{x:0,y:0}, {x:0,y:element.physicsData.height}, {x:0,y:0},{x:0,y:0}], 0x000000);
        shadow.x = element.physicsData.x;
        shadow.y = element.physicsData.y;
        shadows.push(shadow);

        return {element:element, shadows:shadows};
    }

    private function updateShadow(centerX:Number, centerY:Number, shadow:Object):void{
        var posX:Number = shadow.element.physicsData.x;
        var posY:Number = shadow.element.physicsData.y;
        shadow.shadows[0].vertexData.setPosition(2, posX+((posX + shadow.element.physicsData.width) - centerX)*100, posY+((posY + 0) - centerY)*100);
        shadow.shadows[0].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + 0) - centerY)*100);
        shadow.shadows[1].vertexData.setPosition(2, posX+((posX + 0) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[1].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + 0) - centerY)*100);
        shadow.shadows[2].vertexData.setPosition(2, posX+((posX + shadow.element.physicsData.width) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[2].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[3].vertexData.setPosition(2, posX+((posX + 0) - centerX)*100, posY+((posY + shadow.element.physicsData.height) - centerY)*100);
        shadow.shadows[3].vertexData.setPosition(3, posX+((posX + 0) - centerX)*100, posY+((posY + 0) - centerY)*100);

        var matrix:Matrix = new Matrix();
        matrix.translate(shadow.shadows[0].x, shadow.shadows[0].y);
        shadowTexture.draw(shadow.shadows[0], matrix);
        matrix.translate(-shadow.shadows[0].x, -shadow.shadows[0].y);
        matrix.translate(shadow.shadows[1].x, shadow.shadows[1].y);
        shadowTexture.draw(shadow.shadows[1], matrix);
        matrix.translate(-shadow.shadows[1].x, -shadow.shadows[1].y);
        matrix.translate(shadow.shadows[2].x, shadow.shadows[2].y);
        shadowTexture.draw(shadow.shadows[2], matrix);
        matrix.translate(-shadow.shadows[2].x, -shadow.shadows[2].y);
        matrix.translate(shadow.shadows[3].x, shadow.shadows[3].y);
        shadowTexture.draw(shadow.shadows[3], matrix);
    }
}
}
