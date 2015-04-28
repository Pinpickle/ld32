
package entities;


import com.punkiversal.utils.Data;
import com.punkiversal.Screen;
import flash.display.Sprite;
import entities.interactables.Smashable;
import entities.interactables.Collectable;
import entities.interactables.Droppable;
import com.punkiversal.PV;
import entities.GravityTool.GravityMode;
import com.punkiversal.masks.Circle;

import flash.display.Shape;

class Player extends PhysicsEntity
{
	public var gravityTool:GravityTool;

	private var healthBars:Array<Shape> = new Array<Shape>();

	public function new(x:Float, y:Float) {
		super(x, y);

		_forceMap.set(Type.getClassName(Droppable), -100);
		_forceMap.set(Type.getClassName(Collectable), 100);
		_forceMap.set(Type.getClassName(Smashable), 100);
		_forceMap.set(Type.getClassName(Player), 10);

		type = "player";

		graphic = new Sprite();

		var playerShape:Shape = new Shape();
		playerShape.graphics.beginFill(0x666666);
		playerShape.graphics.drawCircle(0, 0, 18);
		playerShape.graphics.endFill();

		playerShape.graphics.lineStyle(3, Collectable.mainColour);
		playerShape.graphics.drawCircle(0, 0, 18);

		cast (graphic, Sprite).addChild(playerShape);

		for (i in 0...health) {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawRect(-2, -8, 4, 16);
			shape.y = 0;
			shape.x = (-Math.floor(health / 2) + i) * 8;
			healthBars.push(shape);
			cast (graphic, Sprite).addChild(shape);
		}


		
		mask = new Circle(20, -20, -20);

		// Uncomment this to check if Flash is still reporting errors
		// gravityTool.x = 0;
		gravityTool = new GravityTool(this);
		layer = 15;
	}

	public static function init() {
		GravityTool.init();
	}

	override public function update() {
		if ((right < 0) || (bottom < 0) || (left > PV.width) || (top > PV.height)) {
			/*x = PV.width / 2;
			y = PV.height / 2;
			xSpeed = 0;
			ySpeed = 0;*/
			Main.playBad();
			health = -1;
		}

		super.update();
	}

	override public function added() {
		scene.add(gravityTool);
	}

	override public function removed() {
		scene.remove(gravityTool);
	}

	override public function render() {
		graphic.rotation = -angle;
		super.render();
	}

	public var health(get, set):Int;
	private var _health:Int = 3;
	private function get_health():Int {
		return _health;
	}
	private function set_health(v:Int):Int {
		if (v < _health) {
			PV.screen.shake(2, 0.2);
		}

		_health = v;
		var counter:Int = 0;
		for (bar in healthBars) {
			counter ++;
			bar.visible = counter <= _health;
		}

		if (health < 0) {
			var score:Int = cast(scene, MainScene).score;
			if (score > Main.highScore) {
				Main.highScore = score;
				Data.write('highscore', Main.highScore);
				Data.save('pinpickle-ld32-save');
			}
			PV.scene = new DeathScene(score);
		}

		return v;
	}

}