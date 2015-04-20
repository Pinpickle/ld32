package entities.interactables;

import flash.display.Shape;
import com.punkiversal.PV;
import com.punkiversal.Entity;

class Interactable extends PhysicsEntity {

    private var _spawner:Spawner;
    public var dead:Bool = false;

    public function new(x:Float, y:Float) {
        super(x, y);
        _forceMap.set(Type.getClassName(Droppable), 100);
        _forceMap.set(Type.getClassName(Collectable), 100);
        _forceMap.set(Type.getClassName(Smashable), 100);
        _forceMap.set(Type.getClassName(Player), 10);
        forceField = true;

        layer = 9;
        graphic = new Shape();
        graphic.alpha = 0;
        type = "collectable";
    }

    override public function render() {
        if (graphic.alpha < 1) {
            graphic.alpha += PV.elapsed * 4;
            if (graphic.alpha > 1) {
                graphic.alpha = 1;
            }
        }
        super.render();
    }

    override public function update() {
        if ((right < 0) || (bottom < 0) || (left > PV.width) || (top > PV.height)) {
            Main.playBad();
            cast (scene, MainScene).player.health -= 1;
            scene.recycle(this);
        }

        super.update();
    }

    override public function added() {
        xSpeed = 0;
        ySpeed = 0;
        aSpeed = 0;
        dead = false;
        graphic.scaleX = graphic.scaleY = 1;
        graphic.alpha = 0;
    }

    override public function removed() {
        _spawner.deChild(this);
        _spawner = null;
        dead = true;
    }

    public function setParent(s:Spawner) {
        _spawner = s;
    }


}
