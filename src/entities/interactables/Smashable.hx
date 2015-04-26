package entities.interactables;

import com.punkiversal.math.Vector;
import com.punkiversal.masks.Polygon;
import com.punkiversal.masks.Hitbox;
import flash.display.Shape;
import com.punkiversal.Entity;

class Smashable extends Interactable
{
	public static var mainColour:Int = 0xAD3E2B;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		_forceMap.set(Type.getClassName(Smashable), 100);

		var trianglePoints:Array<Vector> = [
			new Vector(Math.cos(Math.PI * 0) * 10, 10 * Math.sin(Math.PI * 0)),
			new Vector(Math.cos(Math.PI * 2 / 3) * 10, 10 * Math.sin(Math.PI * 2 / 3)),
			new Vector(Math.cos(Math.PI * 4 / 3) * 10, 10 * Math.sin(Math.PI * 4 / 3))
		];

		cast (graphic, Shape).graphics.beginFill(mainColour);
		cast (graphic, Shape).graphics.moveTo(trianglePoints[0].x, trianglePoints[0].y);
		cast (graphic, Shape).graphics.lineTo(trianglePoints[1].x, trianglePoints[1].y);
		cast (graphic, Shape).graphics.lineTo(trianglePoints[2].x, trianglePoints[2].y);

		snapAngles = [0, 120, 240];

		mask = new Polygon(trianglePoints);

		angle = 90;

		type = "collectable";
	}

	override public function update() {
		var c:Entity;

		if (!dead) {
			c = collide("player", x, y);

			if (c != null) {
				cast (scene, MainScene).player.health -= 1;
				Main.playBad();
				cast (scene, MainScene).animator.consume(this, 'collect');
			}

			c = collide("collectable", x, y);

			if (c != null) {
				if (Std.is(c, Smashable)) {
					cast (scene, MainScene).addScore(10);
					Main.playNice();
					cast (scene, MainScene).animator.consume(this, 'goodbubble', cast c);
				} else {
					cast (scene, MainScene).player.health -= 1;
					Main.playBad();
					cast (scene, MainScene).animator.consume(this, 'badbubble', cast c);
				}
			}
		}



		super.update();
	}

	override public function render() {
		graphic.rotation = -angle;
		super.render();
	}

	override private function set_angle(v:Float):Float {
		cast (mask, Polygon).angle = v;
		_angle = v;
		return _angle;
	}

}