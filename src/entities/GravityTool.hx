
package entities;

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

	private var player:Player;

	private static var modeMappings:Map<GravityMode, String>;
	private static var modes:Array<GravityMode>;

	private var teleCharge:Float = 0;

	public var charge:Float = 100;
	public var chargeMax:Float = 100;

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

		graphic = new Shape();
		cast(graphic, Shape).graphics.beginFill(0xDDDDDD);
		cast(graphic, Shape).graphics.drawCircle(0, 0, 10);

		colorTransform = new ColorTransform();
		graphic.transform.colorTransform = colorTransform;
		physicsEntities = [];
		anglePoint = new Point();
	}

	override public function update() {
		var e:Entity;
		var g:GravityMode;

		for (g in modes) {
			if (Input.pressed(modeMappings.get(g))) {
				mode = g;
			}
		}

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


		if (Input.check('teleport')) {
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
		}

		if (toolActive) {
			chargeAttempt = true;
			if (charge > 0) {
				charge -= 20 * PV.elapsed;
				var effector:Point -> Float -> Float -> PhysicsEntity -> Void;

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

					effector(anglePoint, dis, angle, e);

					e.xSpeed += anglePoint.x;
					e.ySpeed += anglePoint.y;
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
		if (toolActive) {
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

		graphic.transform.colorTransform = colorTransform;

		super.render();
	}

	private function attractEntity(anglePoint:Point, dis:Float, angle:Float, e:PhysicsEntity) {
		PV.angleXY(anglePoint, angle, 10000 / dis);
		anglePoint.x *= PV.elapsed;
		anglePoint.y *= PV.elapsed;
	}

	private function repelEntity(anglePoint:Point, dis:Float, angle:Float, e:PhysicsEntity) {
		PV.angleXY(anglePoint, angle, -10000 / dis);
		anglePoint.x *= PV.elapsed;
		anglePoint.y *= PV.elapsed;
	}

	private function frictionEntity(anglePoint:Point, dis:Float, angle:Float, e:PhysicsEntity) {
		anglePoint.x = Utils.friction(e.xSpeed, 200 / dis);
		anglePoint.y = Utils.friction(e.ySpeed, 200 / dis);
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