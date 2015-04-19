
package entities;


import entities.GravityTool.GravityMode;
import com.punkiversal.masks.Circle;

import flash.display.Shape;

class Player extends PhysicsEntity
{
	public var gravityTool:GravityTool;

	public function new(x:Float, y:Float) {
		super(x, y);

		type = "player";

		graphic = new Shape();
		cast(graphic, Shape).graphics.beginFill(0xFF0000);
		cast(graphic, Shape).graphics.drawCircle(0, 0, 20);
		
		mask = new Circle(20, -20, -20);

		// Uncomment this to check if Flash is still reporting errors
		// gravityTool.x = 0;
		gravityTool = new GravityTool(this);
		layer = 10;
	}

	public static function init() {
		GravityTool.init();
	}

	override public function update() {


		super.update();
	}

	override public function added() {
		scene.add(gravityTool);
	}

	override public function removed() {
		scene.remove(gravityTool);
	}

}