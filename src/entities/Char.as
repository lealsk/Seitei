package entities {

import flash.ui.Keyboard;
import flash.utils.Dictionary;

import starling.textures.Texture;


public class Char extends Entity {

    public function Char(entityName:String) {


        super(entityName);


    }

    public function update(pressedKeys:Dictionary):void {


        if(pressedKeys[Keyboard.W]){

            getView().y -= 5;

        }

        if(pressedKeys[Keyboard.A]){

            getView().x -= 5;

        }

        if(pressedKeys[Keyboard.S]){

            getView().y += 5;

        }

        if(pressedKeys[Keyboard.D]) {

            getView().x += 5;
        }






    }

}





















}
