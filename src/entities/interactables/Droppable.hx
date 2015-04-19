package entities.interactables;

import com.punkiversal.masks.Hitbox;
import flash.display.Shape;

class Droppable extends Interactable
{
    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

        graphic = new Shape();
        cast(graphic, Shape).graphics.beginFill(0xFF0000);
        cast(graphic, Shape).graphics.drawRect(-6, -6, 12, 12);

        mask = new Hitbox(12, 12, -6, -6);

        type = "collectable";

    }

    override public function update() {
        if (collide("player", x, y) != null) {
            scene.recycle(this);
// Add Points
        }

        super.update();
    }

}