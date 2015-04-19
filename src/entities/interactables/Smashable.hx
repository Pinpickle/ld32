package entities.interactables;

import com.punkiversal.masks.Hitbox;
import flash.display.Shape;
import com.punkiversal.Entity;

class Smashable extends Interactable
{

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		graphic = new Shape();
		cast (graphic, Shape).graphics.beginFill(0x0000FF);
		cast (graphic, Shape).graphics.moveTo(Math.cos(Math.PI * 0) * 10, 10 * Math.sin(Math.PI * 0));
		cast (graphic, Shape).graphics.lineTo(Math.cos(Math.PI * 2 / 3) * 10, 10 * Math.sin(Math.PI * 2 / 3));
		cast (graphic, Shape).graphics.lineTo(Math.cos(Math.PI * 4 / 3) * 10, 10 * Math.sin(Math.PI * 4 / 3));
		cast (graphic, Shape).rotation = -90;
		
		mask = new Hitbox(10, 10, -5, -5);

		type = "collectable";
	}

	override public function update() {
		var c:Entity;

		c = collide("player", x, y);

		if (c != null) {
			scene.recycle(this);
		}

		c = collide("collectable", x, y);

		if (c != null) {
			if (Std.instance(c, Smashable) != null) {
				// Add points
			}
			
			scene.recycle(this);
			scene.recycle(c);
		}

		super.update();
	}

}