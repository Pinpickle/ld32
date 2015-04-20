
package entities;

import flash.ui.Mouse;
import flash.display.Sprite;
import com.punkiversal.Entity;
import com.punkiversal.utils.Input;
import com.punkiversal.utils.Key;
import com.punkiversal.PV;
import flash.geom.Point;

import flash.display.Shape;
import flash.geom.ColorTransform;

enum GravityMode {
	ATTRACT;
	REPEL;
	FRICTION;
}

class GravityTool extends Entity
{
	public var toolActive:Bool = false;

	private var colorTransform:ColorTransform;
	private var physicsEntities:Array<PhysicsEntity>;
	private var anglePoint:Point;

	private var animCircle1:Shape;
	private var animCircle2:Shape;

	private var player:Player;

	private static var modeMappings:Map<GravityMode, String>;
	private static var modes:Array<GravityMode>;

	private var teleCharge:Float = 0;

	public var charge:Float = 100;
	public var chargeMax:Float = 100;

	private var graphicAnim:Float = 0;
	private var swapStatus:Bool = false;

	public static function init() {
		Input.define('attract', [Key.A]);
		Input.define('repel', [Key.S]);
		Input.define('friction', [Key.D]);
		Input.define('teleport', [Key.SPACE]);

		modeMappings = new Map<GravityMode, String>();

		modeMappings.set(GravityMode.ATTRACT, 'attract');
		modeMappings.set(GravityMode.REPEL, 'repel');
		modeMappings.set(GravityMode.FRICTION, 'friction');

		modes = [GravityMode.ATTRACT, GravityMode.REPEL, GravityMode.FRICTION];

	}

	function new(p:Player) {
		super(Input.mouseX, Input.mouseY);
		layer = 4;

		player = p;

		graphic = new Sprite();

		animCircle1 = new Shape();
		animCircle1.graphics.beginFill(0xDDDDDD);
		animCircle1.graphics.drawCircle(0, 0, 20);
		animCircle1.scaleX = animCircle1.scaleY = 1.1;

		animCircle2 = new Shape();
		animCircle2.graphics.beginFill(0xDDDDDD);
		animCircle2.graphics.drawCircle(0, 0, 20);
		animCircle2.scaleX = animCircle2.scaleY = 0.9;

		cast (graphic, Sprite).addChild(animCircle1);
		cast (graphic, Sprite).addChild(animCircle2);

		colorTransform = new ColorTransform();
		graphic.transform.colorTransform = colorTransform;
		physicsEntities = [];
		anglePoint = new Point();
	}

	override public function update() {
		var e:Entity;
		var g:GravityMode;

		graphicAnim += PV.elapsed / 2;
		while(graphicAnim > 1) {
			graphicAnim -= 1;
		}

		/*for (g in modes) {
			if (Input.pressed(modeMappings.get(g))) {
				mode = g;
			}
		}*/

		toolActive = Input.mouseDown;

		var playerDis = Math.pow(Input.mouseX - player.x, 2) + Math.pow(Input.mouseY - player.y, 2);
		var playerAngle = PV.angle(player.x, player.y, Input.mouseX, Input.mouseY);

		var chargeAttempt:Bool = false;

		x = Input.mouseX;
		y = Input.mouseY;

		// No need to square the distance if I square the comparison!
		if (playerDis > 22500) {
			PV.angleXY(this, playerAngle, 150, player.x, player.y);
		}


		/*if (Input.check('teleport')) {
			chargeAttempt = true;
			if (charge > 0) {
				charge -= 20 * PV.elapsed;
				teleCharge += 200 * PV.elapsed;
			}
		}

		if (Input.released('teleport')) {
			playerAngle *= PV.RAD;
			player.x += Math.cos(playerAngle) * teleCharge;
			player.y += Math.sin(playerAngle) * teleCharge;

			teleCharge = 0;
		}*/

		if (toolActive) {
			chargeAttempt = true;
			if (charge > 0) {
				charge -= 20 * PV.elapsed;
				var effector:Float -> Float -> PhysicsEntity -> Void;

				switch(mode) {
					case GravityMode.ATTRACT:
						effector = attractEntity;
					case GravityMode.REPEL:
						effector = repelEntity;
					case GravityMode.FRICTION:
						effector = frictionEntity;
				}

				scene.getClass(PhysicsEntity, physicsEntities);
				for (e in physicsEntities) {
					var dis = Math.max(Math.pow(x - e.x, 2) + Math.pow(y - e.y, 2), 100),
						angle = PV.angle(e.x, e.y, x, y);

					effector(dis, angle, e);
				}

#if (cpp||php)
				physicsEntities.splice(0,physicsEntities.length);
#else
				untyped physicsEntities.length = 0;
#end
			}
		}

		if (!chargeAttempt) {
			if (charge < chargeMax) {
				charge += 50 * PV.elapsed;
			}
		}

		if (charge < 0) {
			charge = 0;
		}

		if (charge > chargeMax) {
			charge = chargeMax;
		}


	}

	override public function render() {
		/*if (toolActive) {
			colorTransform.redOffset = 0;
			colorTransform.blueOffset = 0;
			colorTransform.greenOffset = 0;
		} else {
			colorTransform.blueOffset = -50;
			colorTransform.greenOffset = -50;
			colorTransform.redOffset = -50;

			switch(mode) {
				case GravityMode.ATTRACT:
					colorTransform.redOffset = 50;
				case GravityMode.REPEL:
					colorTransform.greenOffset = 50;
				case GravityMode.FRICTION:
					colorTransform.blueOffset = 50;
			}
		}

		graphic.transform.colorTransform = colorTransform;*/
		var anim1Point = (1 - graphicAnim) + 0.5;
		var anim2Point = (1 - graphicAnim);

		if (anim1Point > 1) {
			anim1Point -= 1;
			if (!swapStatus) {
				cast (graphic, Sprite).swapChildren(animCircle1, animCircle2);
				swapStatus = true;
			}
		} else {
			if (swapStatus) {
				cast (graphic, Sprite).swapChildren(animCircle1, animCircle2);
				swapStatus = false;
			}
		}

		animCircle1.scaleX = animCircle1.scaleY = anim1Point + 0.5;
		animCircle1.alpha = Utils.easeUpDown(anim1Point, 0, 1, 1);//Math.sin(Utils.easeInOut(anim1Point / .8 - 0.1, 0, 1, 1) * Math.PI);

		animCircle2.scaleX = animCircle2.scaleY = anim2Point + 0.5;
		animCircle2.alpha = Utils.easeUpDown(anim2Point, 0, 1, 1);

		super.render();
	}

	override public function added() {
#if !debug
		Mouse.hide();
#end
	}

	override public function removed() {
#if !debug
		Mouse.show();
#end
	}

	private function attractEntity(dis:Float, angle:Float, e:PhysicsEntity) {
		e.force(angle, 100000 / dis * PV.elapsed);
	}

	private function repelEntity(dis:Float, angle:Float, e:PhysicsEntity) {
		e.force(angle, -10000 / dis * PV.elapsed);
	}

	private function frictionEntity(dis:Float, angle:Float, e:PhysicsEntity) {
		e.xSpeed += Utils.friction(e.xSpeed, 200 / dis);
		e.ySpeed += Utils.friction(e.ySpeed, 200 / dis);
	}

	public var mode(get, set):GravityMode;
	private function set_mode(val:GravityMode):GravityMode {
		_mode = val;
		return _mode;
	}
	private function get_mode():GravityMode {
		return _mode;
	}
	private var _mode:GravityMode = GravityMode.ATTRACT;
}