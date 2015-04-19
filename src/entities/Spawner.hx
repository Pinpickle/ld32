package entities;

import entities.interactables.Interactable;
import entities.interactables.Collectable;
import entities.interactables.Droppable;
import entities.interactables.Smashable;

import com.punkiversal.PV;
import com.punkiversal.masks.Circle;
import flash.display.Shape;
import com.punkiversal.Entity;

class Spawner extends Entity {

    private static var collectables:Array<Class<Interactable>> = [Collectable, Droppable, Smashable];

    private var timer:Float = 5;
    private var maxCollectables = 3;
    private var collectablesOut:Array<Interactable> = [];

    public function new(x:Float, y:Float) {
        super(x, y);

        graphic = new Shape();
        cast (graphic, Shape).graphics.beginFill(0xCCCCCC);
        cast (graphic, Shape).graphics.drawCircle(0, 0, 20);

        mask = new Circle(20, -20, -20);
        layer = 4;
    }

    override public function added() {
        spawn();
    }

    override public function update() {
        if (collectablesOut.length < 3) {
            if (timer > 0) {
                if (collide('collectable', x, y) == null) {
                    timer -= PV.elapsed;
                } else {
                    timer = 5;
                }
            } else {
                spawn();
                timer = 5;
            }
        }
    }

    public function deChild(e:Interactable) {
        collectablesOut.remove(e);
    }

    public function spawn():Interactable {
        var e:Interactable;
        var c:Class<Interactable> = collectables[Math.floor(collectables.length * Math.random())];

        e = scene.create(c, false);
        e.x = x;
        e.y = y;

        e.setParent(this);
        scene.add(e);

        collectablesOut.push(e);

        return e;
    }
}
