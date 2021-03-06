package entities.interactables;


import com.punkiversal.masks.Hitbox;
import flash.display.Shape;

class Collectable extends Interactable
{
	public static var mainColour:Int = 0x38a6dc;

	public function new(x:Float = 0, y:Float = 0) {
		super(x, y);

		cast(graphic, Shape).graphics.beginFill(mainColour);
		cast(graphic, Shape).graphics.drawCircle(0, 0, 6);
		
		mask = new Hitbox(12, 12, -6, -6);
		
		type = "collectable";
	}

	override public function update() {
		if (collide("player", x, y) != null) {
			Main.playNice();
			cast (scene, MainScene).addScore(10);
			cast (scene, MainScene).animator.consume(this, 'collect');
		}

		super.update();
	}

}