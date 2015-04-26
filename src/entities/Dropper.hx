package entities;

import entities.interactables.Droppable;
import entities.interactables.Interactable;
import flash.display.Shape;
import com.punkiversal.masks.Hitbox;
import com.punkiversal.Entity;
import com.punkiversal.PV;

class Dropper extends Entity {

    public function new(x:Float, y:Float) {
        super(x, y);

        graphic = new Shape();
        cast (graphic, Shape).graphics.beginFill(0xCCCCCC);
        cast (graphic, Shape).graphics.drawRect(-20, -20, 40, 40);
        cast (graphic, Shape).graphics.endFill();

        cast (graphic, Shape).graphics.lineStyle(2, 0xa890b5);
        cast (graphic, Shape).graphics.moveTo(-9, 0);
        cast (graphic, Shape).graphics.lineTo(0, -9);
        cast (graphic, Shape).graphics.lineTo(9, 0);
        cast (graphic, Shape).graphics.lineTo(0, 9);
        cast (graphic, Shape).graphics.lineTo(-9, 0);

        mask = new Hitbox(40, 40, -20, -20);
    }

    override public function update() {
        var interactables:List<Entity> = scene.entitiesForType("collectable");
        var e:Entity;
        var i:Interactable;

        for (e in interactables) {
            i = cast e;

            if ((i.left >= left) && (i.top >= top) && (i.right <= right) && (i.bottom <= bottom)) {
                if (Std.is(i, Droppable)) {
                    cast (scene, MainScene).addScore(10);
                    Main.playNice();
                } else {
                    cast (scene, MainScene).player.health -= 1;
                    Main.playBad();
                }

                cast (scene, MainScene).animator.consume(cast (i, Interactable), 'fall');
            }
        }
    }
}
