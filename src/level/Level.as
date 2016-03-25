package level {
import starling.display.Quad;
import starling.display.Sprite;
import starling.extensions.deferredShading.display.DeferredShadingContainer;
import starling.textures.Texture;
import starling.utils.AssetManager;

public class Level extends Sprite {

    private var _container:DeferredShadingContainer;
    private var _assets:AssetManager;

    public function Level(assets:AssetManager) {

        _assets = assets;

        _container = new DeferredShadingContainer();

        var texture:Texture = _assets.getTexture("enemy1");

        var bg:Quad = new Quad(700, 500, 0xbb8855);
        _container.addChild(bg);

        var crate:Object = createElement();
        crate.castsShadow = true;
        crate.physicsData = new PhysicsData();
        crate.physicsData.owner = crate;
        crate.physicsData.width = 200;
        crate.physicsData.height = 50;
        crate.physicsData.x = 100;
        crate.physicsData.y = 100;
        _physicsDatas.push(crate.physicsData);
        _objects.push(crate);

        var img:Image = new Image(texture);
        img.width = crate.physicsData.width;
        img.height = crate.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        crate.view.sprite = spr;
        _container.addChild(crate.view.sprite);
        _container.addOccluder(crate.view.sprite);


        var enemy:Object = createElement();
        var scale:Number = .25;
        enemy.hidden = true;
        enemy.physicsData = new PhysicsData();
        enemy.physicsData.owner = enemy;
        enemy.physicsData.width = _assets.getTexture("enemy1").width * scale;
        enemy.physicsData.height = _assets.getTexture("enemy1").height * scale;
        enemy.physicsData.x = 50;
        enemy.physicsData.y = 150;
        _physicsDatas.push(enemy.physicsData);
        _objects.push(enemy);

        var img:Image = new Image(_assets.getTexture("enemy1"));
        img.width = enemy.physicsData.width;
        img.height = enemy.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        enemy.view.sprite = spr;
        _container.addHidden(enemy.view.sprite, this);

        var crate2:Object = createElement();

        crate2.castsShadow = true;
        crate2.physicsData = new PhysicsData();
        crate2.physicsData.owner = crate2;
        crate2.physicsData.width = 200;
        crate2.physicsData.height = 50;
        crate2.physicsData.x = 400;
        crate2.physicsData.y = 120;
        _physicsDatas.push(crate2.physicsData);
        _objects.push(crate2);

        var img:Image = new Image(texture);
        img.width = crate2.physicsData.width;
        img.height = crate2.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        crate2.view.sprite = spr;
        _container.addChild(crate2.view.sprite);
        _container.addOccluder(crate2.view.sprite);


        _char = createElement();
        _char.view.sprite = new Quad(30, 30, 0x77ff11);
        _container.addChild(_char.view.sprite);

        _char.physicsData = new PhysicsData();
        _char.physicsData.owner = _char;
        _char.physicsData.width = 30;
        _char.physicsData.height = 30;
        _char.physicsData.x = 200;
        _char.physicsData.y = 200;
        _char.physicsData.checkCollisions = true;
        _physicsDatas.push(_char.physicsData);
        _objects.push(_char);


        _core = createElement();

        _core.castsShadow = true;
        _core.physicsData = new PhysicsData();
        _core.physicsData.owner = _core;
        _core.physicsData.width = 80;
        _core.physicsData.height = 20;
        _core.physicsData.x = 400;
        _core.physicsData.y = 320;
        _physicsDatas.push(_core.physicsData);
        _objects.push(_core);

        var img:Image = new Image(texture);
        img.width = _core.physicsData.width;
        img.height = _core.physicsData.height;
        var spr:Sprite = new Sprite();
        spr.addChild(img);
        _core.view.sprite = spr;
        _container.addChild(_core.view.sprite);
        _container.addOccluder(_core.view.sprite);

        _controlledLight = new SpotLight(0xFFFFFFFF, .2, 800,0);
        _controlledLight.castsShadows = true;
        _controlledLight.angle = Math.PI*.8;
        _container.addChild(_controlledLight);
        destructibleTerrain = new DestructibleTerrain();
        destructibleTerrain.init(_assets.getTexture("test_terrain"));
        _container.setDestructibleTerrain(destructibleTerrain);

        var ambient:AmbientLight = new AmbientLight(0x000000);
        _container.addChild(ambient);

        _physicsDispatcher.addEventListener("collide", onCollide);

    }
}
}
