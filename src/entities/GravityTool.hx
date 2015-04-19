
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

	private static var modeMappings:Map<GravityMode, String>;
	private static var modes:Array<GravityMode>;

	public static function init() {
		Input.define('attract', [Key.A]);
		Input.define('repel', [Key.S]);
		Input.define('friction', [Key.D]);

		modeMappings = new Map<GravityMode, String>();

		modeMappings.set(GravityMode.ATTRACT, 'attract');
		modeMappings.set(GravityMode.REPEL, 'repel');
		modeMappings.set(GravityMode.FRICTION, 'friction');

		modes = [GravityMode.ATTRACT, GravityMode.REPEL, GravityMode.FRICTION];
	}

	function new() {
		super(Input.mouseX, Input.mouseY);

		graphic = new Shape();
		cast(graphic, Shape).graphics.beginFill(0xDDDDDD);
		cast(graphic, Shape).graphics.drawCircle(-5, -5, 10);

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

		x = Input.mouseX;
		y = Input.mouseY;

		if (toolActive) {
			scene.getClass(PhysicsEntity, physicsEntities);
			for (e in physicsEntities) {
				var dis = Math.max(Math.sqrt(Math.pow(x - e.x, 2) + Math.pow(y - e.y, 2)), 5),
					angle = PV.angle(e.x, e.y, x, y);

				//PV.angleXY(anglePoint, angle, 100 / dis);
				switch(mode) {
					case GravityMode.ATTRACT:
						PV.angleXY(anglePoint, angle, 100 / dis);
						anglePoint.x *= PV.elapsed;
						anglePoint.y *= PV.elapsed;
					case GravityMode.REPEL:
						PV.angleXY(anglePoint, angle, -100 / dis);
						anglePoint.x *= PV.elapsed;
						anglePoint.y *= PV.elapsed;
					case GravityMode.FRICTION:
						anglePoint.x = Utils.friction(e.xSpeed, 2 / dis);
						anglePoint.y = Utils.friction(e.ySpeed, 2 / dis);
				}

				e.xSpeed += anglePoint.x;
				e.ySpeed += anglePoint.y;
			}
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