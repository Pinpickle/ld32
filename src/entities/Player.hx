
package entities;

import flash.display.Shape;

class Player extends PhysicsEntity
{
	public var gravityTool:GravityTool;

	public function new(x:Float, y:Float) {
		super(x, y);

		graphic = new Shape();
		cast(graphic, Shape).graphics.beginFill(0xFF0000);
		cast(graphic, Shape).graphics.drawCircle(-10, -10, 20);

		gravityTool = new GravityTool();
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